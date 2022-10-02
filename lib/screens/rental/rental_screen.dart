import 'dart:async';

import 'package:easybikeshare/bloc/rental_bloc/rental_bloc.dart';
import 'package:easybikeshare/models/coordinates.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/models/travel_event.dart';
import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/repositories/feedback_repository.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:easybikeshare/screens/feedback/feedback_screen.dart';
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
  final RentalRepository rentalRepository;
  final TravelRepository travelRepository;
  final FeedbackRepository feedbackRepository;

  final DockRepository dockRepository;
  final FCM firebaseMessaging;

  final String rentalId;

  const RentalScreen(
      {Key? key,
      required this.rentalRepository,
      required this.firebaseMessaging,
      required this.travelRepository,
      required this.feedbackRepository,
      required this.dockRepository,
      required this.rentalId})
      : super(key: key);

  @override
  RentalScreenState createState() => RentalScreenState();
}

class RentalScreenState extends State<RentalScreen> {
  final _locationHandler = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  List<Dock> _docks = [];

  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;
  late final MapController _mapController;

  late final RentalBloc rentalBloc;

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
    Wakelock.enable();

    return Scaffold(
        body: BlocProvider(
            create: (context) {
              rentalBloc = RentalBloc(widget.rentalRepository,
                  widget.dockRepository, widget.feedbackRepository);

              widget.firebaseMessaging.eventCtlr.stream.listen((event) {
                rentalBloc.add(RentalEventReceived(event));
              });

              rentalBloc.add(const GetNearByDocks());

              return rentalBloc;
            },
            child: BlocConsumer<RentalBloc, RentalState>(
                listener: (BuildContext context, state) {
              if (state is BikeLocked) {
                _locationSubscription.cancel();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => FeedbackScreen(
                              rentalRepository: widget.rentalRepository,
                              dockRepository: widget.dockRepository,
                              feedbackRepository: widget.feedbackRepository,
                              rentalId: widget.rentalId,
                            )),
                    (Route<dynamic> route) => route.isFirst);
              }
            }, builder: (context, state) {
              _locationHandler.changeSettings(interval: 2000);
              _locationSubscription = _locationHandler.onLocationChanged
                  .listen((LocationData currentLocation) async {
                var travelEvent = TravelEvent(
                    widget.rentalId,
                    Coordinates(
                        latitude: currentLocation.latitude!,
                        longitude: currentLocation.longitude!));
                widget.travelRepository.createTravelEvent(travelEvent);
              });

              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 540,
                      alignment: Alignment.centerLeft,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          interactiveFlags:
                              InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                          maxZoom: 19,
                          // Stop centering the location marker on the map if user interacted with the map.
                          onPositionChanged:
                              (MapPosition position, bool hasGesture) {
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
                            markers: (state is NearByDocksLoaded)
                                ? buildDockMarkers(state.docks)
                                : [],
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
                        margin:
                            const EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StopWatchPlugin(),
                              const Text("Bike unlocked, enjoy your ride!",
                                  style: TextStyle(fontSize: 20.0)),
                              const Text(
                                  "Connect your bike to a dock when you're done, your payment will be processed automatically!",
                                  style: TextStyle(fontSize: 16.0))
                            ])),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin:
                            const EdgeInsets.only(left: 16, top: 16, right: 16),
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
