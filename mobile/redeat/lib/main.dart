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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = http.Client();

  final authLocalDataSource =
  AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);

  final AuthRepository authRepository = AuthRepositoryImpl(
    localDataSource: authLocalDataSource,
    remoteDataSource: authRemoteDataSource,
  );

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({Key? key, required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        loginUsecase: LoginUseCase(authRepository),
        signupUsecase: SignupUseCase(authRepository),
        logoutUsecase: LogoutUseCase(authRepository),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ecommerce App',
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => EcomHomeScreen());

            case '/signin':
              return MaterialPageRoute(builder: (_) => SignInPage());

            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpPage());

            case '/home':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              final userName = args['userName'] as String? ?? '';
              final userEmail = args['userEmail'] as String? ?? '';
              return MaterialPageRoute(
                  builder: (_) =>
                      HomePage(userName: userName, userEmail: userEmail));

            case '/add':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              final product = args['product'] as Map<String, dynamic>?;
              final userEmail = args['userEmail'] as String? ?? '';
              return MaterialPageRoute(
                  builder: (_) =>
                      AddUpdatePage(product: product, userEmail: userEmail));

            case '/search':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              final userEmail = args['userEmail'] as String? ?? '';
              return MaterialPageRoute(
                  builder: (_) => SearchPage(userEmail: userEmail));

            case '/details':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              final product = args['product'] as Map<String, dynamic>?;
              final onDelete = args['onDelete'] as Function()?;
              if (product == null) {
                return MaterialPageRoute(
                    builder: (_) => Scaffold(
                      body: Center(child: Text('Product data not provided')),
                    ));
              }
              return MaterialPageRoute(
                  builder: (_) =>
                      DetailsPage(product: product, onDelete: onDelete));

            default:
              return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(
                        child: Text('No route defined for ${settings.name}')),
                  ));
          }
        },
      ),
    );
  }
}
