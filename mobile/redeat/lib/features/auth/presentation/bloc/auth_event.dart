import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String email;
  final String password;

  LoggedIn({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignedUp extends AuthEvent {
  final String email;
  final String password;
  final String? name;

  SignedUp({required this.email, required this.password, this.name});

  @override
  List<Object?> get props => [email, password, name];
}

class LoggedOut extends AuthEvent {}
