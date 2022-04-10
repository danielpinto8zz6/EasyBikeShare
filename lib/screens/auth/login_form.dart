import 'dart:async';

import 'package:easybikeshare/bloc/auth_bloc/auth_bloc.dart';
import 'package:easybikeshare/bloc/auth_bloc/auth_event.dart';
import 'package:easybikeshare/bloc/login_bloc/login_bloc.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginForm extends StatefulWidget {
  final UserRepository userRepository;

  const LoginForm({Key? key, required this.userRepository}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginButtonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      if (_usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        _loginButtonController.reset();
        _loginButtonController.start();

        BlocProvider.of<LoginBloc>(context).add(
          LoginButtonPressed(
            username: _usernameController.text,
            password: _passwordController.text,
          ),
        );
      }
    }

    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginFailure) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login failed"),
          backgroundColor: Colors.red,
        ));

        _loginButtonController.error();

        Timer(const Duration(seconds: 4), () {
          _loginButtonController.reset();
        });
      }

      if (state is LoginSuccess) {
        _loginButtonController.success();
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login to your\naccount',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/accent.png',
                    width: 99,
                    height: 4,
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Form(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              RoundedLoadingButton(
                color: primaryBlue,
                controller: _loginButtonController,
                animateOnTap: false,
                onPressed: () => _onLoginButtonPressed(),
                elevation: 0,
                height: 56,
                width: MediaQuery.of(context).size.width,
                borderRadius: 14.0,
                child: Text('Login',
                    style: heading5.copyWith(color: Colors.white)),
              ),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: Text(
                  'OR',
                  style: heading6.copyWith(color: textGrey),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: regular16pt.copyWith(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        Register(),
                      );
                    },
                    child: Text(
                      'Register',
                      style: regular16pt.copyWith(color: primaryBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }));
  }
}
