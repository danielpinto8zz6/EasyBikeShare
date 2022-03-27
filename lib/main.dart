import 'package:dio/dio.dart';
import 'package:easybikeshare/repositories/bike_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/token_repository.dart';
import 'package:easybikeshare/screens/auth/login_screen.dart';
import 'package:easybikeshare/screens/near_by_docks/near_by_docks_screen.dart';
import 'package:easybikeshare/screens/register/register_screen.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/style/colors.dart' as Style;
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc/auth.dart';
import 'repositories/user_repository.dart';
import 'screens/auth/intro_screen.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print(error);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = SimpleBlocObserver();

  final dio = Dio();
  final userRepository = UserRepository(dio: dio);
  final dockRepository = DockRepository(dio: dio);
  final tokenRepository = TokenRepository(dio: dio);
  final bikeRepository = BikeRepository(dio: dio);
  final rentalRepository = RentalRepository(dio: dio);

  var token = await userRepository.getToken() ?? "";
  dio.options.headers["Authorization"] = "Bearer " + token;
  dio.options.headers["Accept"] = "*/*";

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: MyApp(
        userRepository: userRepository,
        dockRepository: dockRepository,
        tokenRepository: tokenRepository,
        bikeRepository: bikeRepository,
        rentalRepository: rentalRepository,
        key: null,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final DockRepository dockRepository;
  final TokenRepository tokenRepository;
  final BikeRepository bikeRepository;
  final RentalRepository rentalRepository;

  MyApp(
      {Key? key,
      required this.userRepository,
      required this.dockRepository,
      required this.tokenRepository,
      required this.bikeRepository,
      required this.rentalRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('mn', 'MN'),
      theme: AppTheme.lightTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return NearByDocksScreen(
              dockRepository: dockRepository,
              userRepository: userRepository,
              tokenRepository: tokenRepository,
              bikeRepository: bikeRepository,
              rentalRepository: rentalRepository,
            );
          }
          if (state is AuthenticationUnauthenticated) {
            return IntroPage(userRepository: userRepository);
          }
          if (state is AuthenticationLoading) {
            return Scaffold(
              body: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    SizedBox(
                      height: 25.0,
                      width: 25.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Style.Colors.mainColor),
                        strokeWidth: 4.0,
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          if (state is RedirectingToRegister) {
            return RegisterScreen(userRepository: userRepository);
          }

          if (state is RedirectingToLogin) {
            return LoginScreen(userRepository: userRepository);
          }

          return Scaffold(
            body: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    height: 25.0,
                    width: 25.0,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Style.Colors.mainColor),
                      strokeWidth: 4.0,
                    ),
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
