import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUsecase;
  final SignupUseCase signupUsecase;
  final LogoutUseCase logoutUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.signupUsecase,
    required this.logoutUsecase,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<SignedUp>(_onSignedUp);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    print(' [AuthBloc] App started');
    emit(AuthUnauthenticated());
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    print('[AuthBloc] LoggedIn event received → email: ${event.email}');
    emit(AuthLoading());
    try {
      final user = await loginUsecase.call(email: event.email, password: event.password);
      print('[AuthBloc] Login success → $user');
      emit(AuthAuthenticated(user: user));
    } on ServerException {
      print('[AuthBloc] ServerException during login');
      emit(AuthFailure(message: "Login failed. Please check your credentials."));
    } catch (e, stack) {
      print('[AuthBloc] Unknown error during login: $e');
      print(stack);
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onSignedUp(SignedUp event, Emitter<AuthState> emit) async {
    print('[AuthBloc] SignedUp event received → name: ${event.name}, email: ${event.email}');
    emit(AuthLoading());
    try {
      final user = await signupUsecase.call(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      print('[AuthBloc] Signup success → $user');
      emit(AuthAuthenticated(user: user));
    } on ServerException {
      print('[AuthBloc] ServerException during signup');
      emit(AuthFailure(message: "Sign up failed. Please try again."));
    } catch (e, stack) {
      print('[AuthBloc] Unknown error during signup: $e');
      print(stack);
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    print('[AuthBloc] LoggedOut event received');
    await logoutUsecase.call();
    emit(AuthUnauthenticated());
  }
}
