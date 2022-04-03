import 'package:easybikeshare/bloc/auth_bloc/auth.dart';
import 'package:easybikeshare/bloc/register_bloc/register_bloc.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easybikeshare/style/colors.dart' as Style;

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

  @override
  Widget build(BuildContext context) {
    _onRegisterButtonPressed() {
      BlocProvider.of<RegisterBloc>(context).add(
        RegisterButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
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
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 80.0),
            child: Form(
              child: Column(
                children: [
                  Container(
                      height: 200.0,
                      padding: const EdgeInsets.only(bottom: 20.0, top: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "BIKESHARE",
                            style: TextStyle(
                                color: Style.Colors.mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Rent a bike, from anywhere, to anywhere",
                            style: TextStyle(
                                fontSize: 10.0, color: Colors.black38),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    style: const TextStyle(
                        fontSize: 14.0,
                        color: Style.Colors.titleColor,
                        fontWeight: FontWeight.bold),
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(EvaIcons.emailOutline,
                          color: Colors.black26),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(30.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Style.Colors.mainColor),
                          borderRadius: BorderRadius.circular(30.0)),
                      contentPadding:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                      labelText: "Username",
                      hintStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Style.Colors.grey,
                          fontWeight: FontWeight.w500),
                      labelStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    autocorrect: false,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    style: const TextStyle(
                        fontSize: 14.0,
                        color: Style.Colors.titleColor,
                        fontWeight: FontWeight.bold),
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        EvaIcons.lockOutline,
                        color: Colors.black26,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(30.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Style.Colors.mainColor),
                          borderRadius: BorderRadius.circular(30.0)),
                      contentPadding:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                      labelText: "Password",
                      hintStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Style.Colors.grey,
                          fontWeight: FontWeight.w500),
                      labelStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    autocorrect: false,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        child: Text(
                      "Forget password?",
                      style: TextStyle(color: Colors.black45, fontSize: 12.0),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                            height: 45,
                            child: state is RegisterLoading
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          SizedBox(
                                            height: 25.0,
                                            width: 25.0,
                                            child: CupertinoActivityIndicator(),
                                          )
                                        ],
                                      ))
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: _onRegisterButtonPressed,
                                    child: const Text("REGISTER",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Already have an account?",
                                style: TextStyle(color: Style.Colors.grey),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 5.0),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: TextButton(
                                    onPressed: () {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(
                                        RedirectedToLogin(),
                                      );
                                    },
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Style.Colors.mainColor,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
