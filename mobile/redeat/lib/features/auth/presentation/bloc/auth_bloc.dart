import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUsecase;
  final SignupUseCase signupusecase;
  final LogoutUseCase logoutusecase;

  AuthBloc({
    required this.loginUsecase,
    required this.signupusecase,
    required this.logoutusecase,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<SignedUp>(_onSignedUp);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {

    emit(AuthUnauthenticated());
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUsecase.call(email: event.email, password: event.password);
      emit(AuthAuthenticated(user: user));
    } on ServerException {
      emit(AuthFailure(message: "Login failed. Please try again."));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onSignedUp(SignedUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signupusecase.call(email: event.email, password: event.password, name: event.name);
      emit(AuthAuthenticated(user: user));
    } on ServerException {
      emit(AuthFailure(message: "Sign up failed. Please try again."));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await logoutusecase.call();
    emit(AuthUnauthenticated());
  }
}
