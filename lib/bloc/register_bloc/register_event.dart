part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String password;

  const RegisterButtonPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() =>
      'RegisterButtonPressed { username: $username, password: $password }';
}

class RedirectLoginButtonPressed extends RegisterEvent {
  @override
  String toString() => 'RedirectLoginButtonPressed';

  @override
  List<Object?> get props => [];
}
