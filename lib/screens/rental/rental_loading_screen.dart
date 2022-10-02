import 'package:easybikeshare/bloc/rental_bloc/rental_bloc.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/repositories/feedback_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:easybikeshare/screens/rental/rental_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';
import 'package:wakelock/wakelock.dart';

class RentalLoadingScreen extends StatefulWidget {
  final String bikeId;
  final RentalRepository rentalRepository;
  final TravelRepository travelRepository;
  final FeedbackRepository feedbackRepository;

  final DockRepository dockRepository;
  final FCM firebaseMessaging;

  const RentalLoadingScreen(
      {Key? key,
      required this.bikeId,
      required this.rentalRepository,
      required this.firebaseMessaging,
      required this.travelRepository,
      required this.feedbackRepository,
      required this.dockRepository})
      : super(key: key);

  @override
  RentalLoadingScreenState createState() => RentalLoadingScreenState();
}

class RentalLoadingScreenState extends State<RentalLoadingScreen> {
  late final RentalBloc rentalBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String rentalId = '';
    Wakelock.enable();

    return Scaffold(
        body: BlocProvider(
            create: (context) {
              rentalBloc = RentalBloc(widget.rentalRepository,
                  widget.dockRepository, widget.feedbackRepository)
                ..add(LoadRental(widget.bikeId));

              widget.firebaseMessaging.eventCtlr.stream.listen((event) {
                rentalBloc.add(RentalEventReceived(event));
              });

              return rentalBloc;
            },
            child: BlocConsumer<RentalBloc, RentalState>(
                listener: (BuildContext context, state) {
              if (state is RentalFailed) {
                Navigator.pop(context);
              }
            }, builder: (context, state) {
              if (state is RentalAccepted) {
                rentalId = state.rental.id;
              }

              return SplashScreenView(
                navigateWhere: state is BikeUnlocked,
                navigateRoute: RentalScreen(
                    key: widget.key,
                    dockRepository: widget.dockRepository,
                    feedbackRepository: widget.feedbackRepository,
                    firebaseMessaging: widget.firebaseMessaging,
                    rentalRepository: widget.rentalRepository,
                    travelRepository: widget.travelRepository,
                    rentalId: rentalId),
                text: WavyAnimatedText(
                  "Unlocking bike...",
                  textStyle: const TextStyle(
                    color: Color(0xff2972ff),
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                imageSrc: "assets/images/bicycle.png",
                logoSize: 250,
              );
            })));
  }
}
