import 'package:easybikeshare/bloc/auth_bloc/auth.dart';
import 'package:easybikeshare/bloc/register_bloc/register_bloc.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository userRepository;

  const RegisterScreen({Key? key, required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return RegisterBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: RegisterForm(userRepository: userRepository),
      ),
    );
  }
}
