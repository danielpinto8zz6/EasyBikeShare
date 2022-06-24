import 'package:dio/dio.dart';
import 'package:easybikeshare/repositories/bike_repository.dart';
import 'package:easybikeshare/repositories/payment_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/token_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:easybikeshare/screens/auth/login_screen.dart';
import 'package:easybikeshare/screens/main/main_screen.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/screens/register/register_screen.dart';
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc/auth.dart';
import 'notification.dart';
import 'repositories/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final dio = Dio();
  final userRepository = UserRepository(dio: dio);
  final dockRepository = DockRepository(dio: dio);
  final tokenRepository = TokenRepository(dio: dio);
  final bikeRepository = BikeRepository(dio: dio);
  final travelRepository = TravelRepository(dio: dio);
  final rentalRepository =
      RentalRepository(dio: dio, dockRepository: dockRepository);
  final paymentRepository = PaymentRepository(dio: dio);

  final firebaseMessaging =
      FCM(userRepository: userRepository, tokenRepository: tokenRepository);
  firebaseMessaging.setNotifications();

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
          paymentRepository: paymentRepository,
          travelRepository: travelRepository,
          firebaseMessaging: firebaseMessaging,
          dio: dio,
          key: const Key("bikeshare")),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final DockRepository dockRepository;
  final TokenRepository tokenRepository;
  final BikeRepository bikeRepository;
  final RentalRepository rentalRepository;
  final PaymentRepository paymentRepository;
  final TravelRepository travelRepository;
  final FCM firebaseMessaging;
  final Dio dio;

  const MyApp(
      {Key? key,
      required this.userRepository,
      required this.dockRepository,
      required this.tokenRepository,
      required this.bikeRepository,
      required this.rentalRepository,
      required this.paymentRepository,
      required this.firebaseMessaging,
      required this.dio,
      required this.travelRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            firebaseMessaging.setToken(state.username);

            dio.options.headers["Authorization"] = "Bearer " + state.token;
            dio.options.headers["Accept"] = "*/*";

            return MainScreen(
              dockRepository: dockRepository,
              userRepository: userRepository,
              tokenRepository: tokenRepository,
              bikeRepository: bikeRepository,
              rentalRepository: rentalRepository,
              paymentRepository: paymentRepository,
              travelRepository: travelRepository,
              firebaseMessaging: firebaseMessaging,
            );
          }

          if (state is AuthenticationUnauthenticated) {
            return LoginScreen(userRepository: userRepository);
          }

          if (state is Registering) {
            return RegisterScreen(userRepository: userRepository);
          }

          if (state is LogingIn) {
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
                      // valueColor:
                      //     AlwaysStoppedAnimation<Color>(Style.Colors.mainColor),
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
