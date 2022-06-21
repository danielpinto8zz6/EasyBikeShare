import 'package:easybikeshare/bloc/rental_bloc/rental_bloc.dart';
import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RentalScreen extends StatefulWidget {
  final String bikeId;
  final RentalRepository rentalRepository;
  final FCM firebaseMessaging;

  const RentalScreen(
      {Key? key,
      required this.bikeId,
      required this.rentalRepository,
      required this.firebaseMessaging})
      : super(key: key);

  @override
  _RentalScreenState createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (context) {
              var bloc = RentalBloc(widget.rentalRepository)
                ..add(LoadRental(widget.bikeId));

              widget.firebaseMessaging.eventCtlr.stream.listen((event) {
                bloc.add(RentalEventReceived(event));
              });

              return bloc;
            },
            child: BlocListener<RentalBloc, RentalState>(
                listener: (context, state) {},
                child: BlocBuilder<RentalBloc, RentalState>(
                    builder: (context, state) {
                  if (state is BikeReserved) {
                    return Container(
                        height: 500,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              Text("Bike reserved")
                            ],
                          ),
                        ));
                  }
                  if (state is BikeValidated) {
                    return Container(
                        height: 500,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              Text("Bike validated")
                            ],
                          ),
                        ));
                  }
                  if (state is BikeUnlocked) {
                    return Container(
                        height: 500,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              Text("Bike unlocked")
                            ],
                          ),
                        ));
                  }
                  if (state is BikeValidationFailed) {
                    return Container(
                        height: 500,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              Text("Validation failed")
                            ],
                          ),
                        ));
                  }
                  if (state is BikeUnlockFailed) {
                    return Container(
                        height: 500,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              Text("Unlock failed")
                            ],
                          ),
                        ));
                  }
                  if (state is BikeReservationFailed) {
                    return Container(
                        height: 500,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              CircularProgressIndicator(),
                              Text("Reservation failed")
                            ],
                          ),
                        ));
                  }

                  return Container(
                      height: 500,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            CircularProgressIndicator(),
                            Text("Reserving bike")
                          ],
                        ),
                      ));
                }))));
  }
}
