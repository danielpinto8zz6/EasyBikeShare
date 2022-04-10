import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String username;

  const LoggedIn({required this.token, required this.username});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn { username: $username token: $token }';
}

class LoggedOut extends AuthenticationEvent {}

class Register extends AuthenticationEvent {}

class Login extends AuthenticationEvent {}
