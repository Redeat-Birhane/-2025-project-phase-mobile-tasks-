import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';
import 'features/auth/presentation/pages/authenticated_home_page.dart';
import 'features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = http.Client();

  final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);

  final authRepository = AuthRepositoryImpl(
    localDataSource: authLocalDataSource,
    remoteDataSource: authRemoteDataSource,
  );

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;

  const MyApp({Key? key, required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        loginUsecase: LoginUseCase(authRepository),
        signupusecase: SignupUseCase(authRepository),
        logoutusecase: LogoutUseCase(authRepository),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ecommerce App',
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(),
          '/signin': (context) => SignInPage(),
          '/signup': (context) => SignUpPage(),
          '/home': (context) => AuthenticatedHomePage(),
        },
      ),
    );
  }
}
