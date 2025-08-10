import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';

import 'features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';

import 'features/presentation/pages/home.dart';
import 'features/presentation/pages/add.dart';
import 'features/presentation/pages/search.dart';
import 'features/presentation/pages/details.dart';

import 'features/app_gateway/presentation/app_gateway_page.dart';
import 'features/chat/data/datasources/chat_remote_data_source_impl.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/usecases/delete_chat_usecase.dart';
import 'features/chat/domain/usecases/get_chat_list_usecase.dart';
import 'features/chat/domain/usecases/get_messages_usecase.dart';
import 'features/chat/domain/usecases/initiate_chat_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/pages/chat_list_page.dart';

import 'core/constants/api_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = http.Client();

  // Auth data sources and repository
  final authLocalDataSource =
  AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);

  final AuthRepository authRepository = AuthRepositoryImpl(
    localDataSource: authLocalDataSource,
    remoteDataSource: authRemoteDataSource,
  );

  // Chat data source and repository
  final chatRemoteDataSource = ChatRemoteDataSourceImpl(
    client: httpClient,
    baseUrl: ApiConstants.baseUrlV3,
    tokenProvider: () async => sharedPreferences.getString('auth_token') ?? '',
  );

  final chatRepository = ChatRepositoryImpl(remoteDataSource: chatRemoteDataSource);

  // Initialize Blocs
  final authBloc = AuthBloc(
    loginUsecase: LoginUseCase(authRepository),
    signupUsecase: SignupUseCase(authRepository),
    logoutUsecase: LogoutUseCase(authRepository),
  );

  final chatBloc = ChatBloc(
    chatRepository: chatRepository,
    getChatListUseCase: GetChatListUseCase(chatRepository),
    getMessagesUseCase: GetMessagesUseCase(chatRepository),
    sendMessageUseCase: SendMessageUseCase(chatRepository),
    deleteChatUseCase: DeleteChatUseCase(chatRepository),
    initiateChatUseCase: InitiateChatUseCase(chatRepository),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<ChatBloc>.value(value: chatBloc),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce App',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => EcomHomeScreen());

        // Auth routes
          case '/signin':
            return MaterialPageRoute(builder: (_) => SignInPage());

          case '/signup':
            return MaterialPageRoute(builder: (_) => SignUpPage());

          case '/appGateway':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final userName = args['userName'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => AppGatewayPage(userName: userName),
            );

        // Product routes
          case '/home':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final userName = args['userName'] as String? ?? '';
            final userEmail = args['userEmail'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => HomePage(userName: userName, userEmail: userEmail),
            );

          case '/add':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final product = args['product'] as Map<String, dynamic>?;
            final userEmail = args['userEmail'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => AddUpdatePage(product: product, userEmail: userEmail),
            );

          case '/search':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final userEmail = args['userEmail'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => SearchPage(userEmail: userEmail),
            );

          case '/details':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final product = args['product'] as Map<String, dynamic>?;
            final onDelete = args['onDelete'] as Function()?;
            if (product == null) {
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(child: Text('Product data not provided')),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (_) => DetailsPage(product: product, onDelete: onDelete),
            );

        // Chat routes
          case '/chatList':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final currentUserId = args['currentUserId'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => ChatListScreen(currentUserId: currentUserId),
            );


          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('No route defined for ${settings.name}')),
              ),
            );
        }
      },
    );
  }
}
