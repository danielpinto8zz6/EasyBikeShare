import 'dart:async';

import 'package:easybikeshare/bloc/rental_bloc/rental_bloc.dart';
import 'package:easybikeshare/models/coordinates.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/models/travel_event.dart';
import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:easybikeshare/screens/widgets/stopwatch.dart';
import 'package:easybikeshare/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wakelock/wakelock.dart';

class RentalScreen extends StatefulWidget {
  final String bikeId;
  final RentalRepository rentalRepository;
  final TravelRepository travelRepository;
  final DockRepository dockRepository;
  final FCM firebaseMessaging;

  const RentalScreen(
      {Key? key,
      required this.bikeId,
      required this.rentalRepository,
      required this.firebaseMessaging,
      required this.travelRepository,
      required this.dockRepository})
      : super(key: key);

  @override
  RentalScreenState createState() => RentalScreenState();
}

class RentalScreenState extends State<RentalScreen> {
  final _locationHandler = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  late Rental rental;
  List<Dock> _docks = [];

  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double?>();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    _locationSubscription.cancel();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(create: (context) {
      var bloc = RentalBloc(widget.rentalRepository, widget.dockRepository)
        ..add(LoadRental(widget.bikeId));

      widget.firebaseMessaging.eventCtlr.stream.listen((event) {
        bloc.add(RentalEventReceived(event));
      });

      return bloc;
    }, child: BlocBuilder<RentalBloc, RentalState>(builder: (context, state) {
      var currentState = 'Loading....';

      if (state is RentalAccepted) {
        rental = state.rental;
      }

      if (state is BikeReserved) {
        currentState = "Bike reserved, validating bike...";
      }
      if (state is BikeValidated) {
        currentState = "Bike validated, unlocking...";
      }
      if (state is BikeUnlocked) {
        currentState = "Bike unlocked, enjoy your ride!";
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

        Wakelock.enable();

        return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: 600,
            alignment: Alignment.centerLeft,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                maxZoom: 19,
                // Stop centering the location marker on the map if user interacted with the map.
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  if (hasGesture) {
                    setState(
                      () => _centerOnLocationUpdate =
                          CenterOnLocationUpdate.never,
                    );
                  }
                },
              ),

              // ignore: sort_child_properties_last
              children: [
                TileLayerWidget(
                  options: TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    maxZoom: 19,
                  ),
                ),
                MarkerLayerWidget(
                    options: MarkerLayerOptions(
                  markers: buildDockMarkers(state.docks),
                )),
                LocationMarkerLayerWidget(
                  plugin: LocationMarkerPlugin(
                    centerCurrentLocationStream:
                        _centerCurrentLocationStreamController.stream,
                    centerOnLocationUpdate: _centerOnLocationUpdate,
                  ),
                ),
              ],
              nonRotatedChildren: [
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: FloatingActionButton(
                    backgroundColor: primaryBlue,
                    onPressed: () {
                      // Automatically center the location marker on the map when location updated until user interact with the map.
                      setState(
                        () => _centerOnLocationUpdate =
                            CenterOnLocationUpdate.always,
                      );
                      // Center the location marker on the map and zoom the map to level 18.
                      _centerCurrentLocationStreamController.add(18);
                    },
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StopWatchPlugin(),
                    Text(currentState, style: const TextStyle(fontSize: 20.0)),
                    const Text(
                        "Connect your bike to a dock when you're done, your payment will be processed automatically!",
                        style: TextStyle(fontSize: 16.0))
                  ])),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: RoundedLoadingButton(
                color: Colors.red,
                controller: RoundedLoadingButtonController(),
                animateOnTap: false,
                onPressed: () => Navigator.of(context).pop(),
                elevation: 0,
                height: 56,
                width: MediaQuery.of(context).size.width,
                borderRadius: 14.0,
                child: Text('Already locked bike',
                    style: heading5.copyWith(color: Colors.white)),
              ))
        ]);
      }

      if (state is BikeAttached) {
        Wakelock.disable();
        _locationSubscription.cancel();

        Navigator.pop(context);
      }
      if (state is BikeValidationFailed) {}
      if (state is BikeUnlockFailed) {}
      if (state is BikeReservationFailed) {}

      return Center(
        child: Text(currentState, style: const TextStyle(fontSize: 20.0)),
      );
    })));
  }

  List<Marker> get _markers => _docks
      .map(
        (dock) => Marker(
          point: LatLng(dock.coordinates.latitude, dock.coordinates.longitude),
          width: 40,
          height: 40,
          anchorPos: AnchorPos.align(AnchorAlign.top),
          builder: (BuildContext context) {
            return GestureDetector(
              child: const Icon(Icons.location_on, size: 40),
            );
          },
        ),
      )
      .toList();

  buildDockMarkers(List<Dock> docks) {
    _docks = docks;

    return _markers;
  }
}
