import 'dart:async';

import 'package:easybikeshare/bloc/auth_bloc/auth_bloc.dart';
import 'package:easybikeshare/bloc/auth_bloc/auth_event.dart';
import 'package:easybikeshare/bloc/register_bloc/register_bloc.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/screens/auth/login_screen.dart';
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterForm extends StatefulWidget {
  final UserRepository userRepository;

  const RegisterForm({Key? key, required this.userRepository})
      : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _registerButtonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    _onRegisterButtonPressed() {
      if (_usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordController.text == _passwordConfirmationController.text) {
        _registerButtonController.reset();
        _registerButtonController.start();
        BlocProvider.of<RegisterBloc>(context).add(
          RegisterButtonPressed(
            username: _usernameController.text,
            password: _passwordController.text,
          ),
        );
      }
    }

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Register failed."),
              backgroundColor: Colors.red,
            ),
          );

          _registerButtonController.error();

          Timer(const Duration(seconds: 4), () {
            _registerButtonController.reset();
          });
        }

        if (state is Registered) {
          _registerButtonController.success();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginScreen(
                    userRepository: widget.userRepository,
                  )));
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
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
                        'Register new\naccount',
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
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: textWhiteGrey,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: TextFormField(
                            controller: _passwordConfirmationController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password Confirmation',
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
                    animateOnTap: false,
                    color: primaryBlue,
                    controller: _registerButtonController,
                    onPressed: () => _onRegisterButtonPressed(),
                    elevation: 0,
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    borderRadius: 14.0,
                    child: Text('Register',
                        style: heading5.copyWith(color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: regular16pt.copyWith(color: textGrey),
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            Login(),
                          );
                        },
                        child: Text(
                          'Login',
                          style: regular16pt.copyWith(color: primaryBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
