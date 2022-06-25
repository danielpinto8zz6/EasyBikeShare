import 'dart:async';

import 'package:easybikeshare/bloc/rental_bloc/rental_bloc.dart';
import 'package:easybikeshare/models/coordinates.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/models/travel_event.dart';
import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:screen_loader/screen_loader.dart';

class RentalScreen extends StatefulWidget {
  final String bikeId;
  final RentalRepository rentalRepository;
  final TravelRepository travelRepository;
  final FCM firebaseMessaging;

  const RentalScreen(
      {Key? key,
      required this.bikeId,
      required this.rentalRepository,
      required this.firebaseMessaging,
      required this.travelRepository})
      : super(key: key);

  @override
  _RentalScreenState createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> with ScreenLoader {
  final _locationHandler = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  late final Rental rental;
  String currentState = '';

  updateCurrentState(String state) {
    setState(() {
      currentState = state;
    });
  }

  @override
  loader() {
    return AlertDialog(
      title: Text(currentState),
    );
  }

  @override
  loadingBgBlur() => 10.0;

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
            child: BlocListener<RentalBloc, RentalState>(listener:
                (context, state) {
              if (state is RentalAccepted) {
                rental = state.rental;
                startLoading();
              }

              if (state is BikeReserved) {
                updateCurrentState("Bike reserved, validating bike...");
              }
              if (state is BikeValidated) {
                updateCurrentState("Bike validated, unlocking...");
              }
              if (state is BikeUnlocked) {
                updateCurrentState("Bike unlocked, enjoy your ride");
                stopLoading();
                _locationHandler.changeSettings(interval: 2000);
                _locationSubscription = _locationHandler.onLocationChanged
                    .listen((LocationData currentLocation) async {
                  print(
                      'Location: ${currentLocation.latitude}, ${currentLocation.longitude}');
                  var travelEvent = TravelEvent(
                      rental.id,
                      Coordinates(
                          latitude: currentLocation.latitude!,
                          longitude: currentLocation.longitude!));
                  widget.travelRepository.createTravelEvent(travelEvent);
                });
              }
              if (state is BikeLocked) {
                _locationSubscription.cancel();

                Navigator.of(context).pop();
              }
              if (state is BikeValidationFailed) {}
              if (state is BikeUnlockFailed) {}
              if (state is BikeReservationFailed) {}
            }, child:
                BlocBuilder<RentalBloc, RentalState>(builder: (context, state) {
              return Container(
                  height: 500,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlutterMap(
                          options: MapOptions(zoom: 15),
                          layers: [
                            TileLayerOptions(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c'])
                          ],
                        )
                      ],
                    ),
                  ));
            }))));
  }
}
