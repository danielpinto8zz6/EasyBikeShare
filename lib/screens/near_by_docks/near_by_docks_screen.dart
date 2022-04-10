import 'dart:async';

import 'package:easybikeshare/bloc/near_by_docks_bloc/nearby_docks_bloc.dart';
import 'package:easybikeshare/bloc/near_by_docks_bloc/nearby_docks_event.dart';
import 'package:easybikeshare/bloc/near_by_docks_bloc/nearby_docks_state.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:easybikeshare/notification.dart';
import 'package:easybikeshare/providers/cachted_tile_provider.dart';
import 'package:easybikeshare/repositories/bike_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/token_repository.dart';
import 'package:easybikeshare/repositories/user_repository.dart';
import 'package:easybikeshare/screens/bike_scanner/bike_scanner_screen.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rxdart/rxdart.dart';

class NearByDocksScreen extends StatefulWidget {
  final DockRepository dockRepository;
  final UserRepository userRepository;
  final TokenRepository tokenRepository;
  final BikeRepository bikeRepository;
  final RentalRepository rentalRepository;
  final FCM firebaseMessaging;

  const NearByDocksScreen(
      {Key? key,
      required this.dockRepository,
      required this.userRepository,
      required this.tokenRepository,
      required this.bikeRepository,
      required this.rentalRepository,
      required this.firebaseMessaging})
      : super(key: key);

  @override
  _NearByDocksScreenState createState() => _NearByDocksScreenState();
}

class _NearByDocksScreenState extends State<NearByDocksScreen> {
  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double> _centerCurrentLocationStreamController;

  late final MapController _mapController;
  late final PopupController _popupLayerController;
  List<Dock> _docks = [];

  late final NearbyDocksBloc bloc;

  @override
  void initState() {
    super.initState();
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = BehaviorSubject<double>();
    _mapController = MapController();
    _popupLayerController = PopupController();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          bloc = NearbyDocksBloc(
              dockRepository: widget.dockRepository,
              mapController: _mapController,
              bikeRepository: widget.bikeRepository)
            ..add(const GetNearByDocks());

          return bloc;
        },
        child: BlocListener<NearbyDocksBloc, NearByDocksState>(
            listener: (context, state) {
          if (state is DockDetailsLoading) {
            final provider = BlocProvider.of<NearbyDocksBloc>(context);

            showDockDetailsModal(provider);
          }
        }, child: BlocBuilder<NearbyDocksBloc, NearByDocksState>(
                builder: (context, nearByDocksState) {
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              plugins: [
                MarkerClusterPlugin(),
              ],
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              maxZoom: 19,
              onTap: (tapPosition, point) =>
                  _popupLayerController.hideAllPopups(),
              // Stop centering the location marker on the map if user interacted with the map.
              onPositionChanged: (MapPosition position, bool hasGesture) {
                if (hasGesture) {
                  setState(() =>
                      _centerOnLocationUpdate = CenterOnLocationUpdate.never);
                }
              },
            ),
            children: [
              TileLayerWidget(
                  options: TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: const CachedTileProvider(),
                subdomains: ['a', 'b', 'c'],
                maxZoom: 19,
              )),
              MarkerLayerWidget(
                  options: MarkerLayerOptions(
                markers: (nearByDocksState is NearByDocksLoaded)
                    ? buildDockMarkers(nearByDocksState.docks)
                    : [],
              )),
              LocationMarkerLayerWidget(
                plugin: LocationMarkerPlugin(
                  centerCurrentLocationStream:
                      _centerCurrentLocationStreamController.stream,
                  centerOnLocationUpdate: _centerOnLocationUpdate,
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                height: 35,
                width: 35,
                child: FloatingActionButton(
                  onPressed: () {
                    // Automatically center the location marker on the map when location updated until user interact with the map.
                    setState(() => _centerOnLocationUpdate =
                        CenterOnLocationUpdate.always);
                    // Center the location marker on the map and zoom the map to level 16.
                    _centerCurrentLocationStreamController.add(16);
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 120,
                  size: const Size(40, 40),
                  fitBoundsOptions: const FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  markers: _markers,
                  polygonOptions: const PolygonOptions(
                      borderColor: Colors.blueAccent,
                      color: Colors.black12,
                      borderStrokeWidth: 3),
                  builder: (context, markers) {
                    return FloatingActionButton(
                      child: Text(markers.length.toString()),
                      onPressed: null,
                    );
                  },
                ),
              )
            ],
          );
        })));
  }

  List<Marker> get _markers => _docks
      .map(
        (dock) => Marker(
          point: LatLng(dock.coordinates.latitude, dock.coordinates.longitude),
          width: 40,
          height: 40,
          builder: (BuildContext ctx) {
            return GestureDetector(
              onTap: () {
                bloc.add(DockDetailsButtonPressed(dock));
              },
              child: const Icon(Icons.location_on, size: 40),
            );
          },
          anchorPos: AnchorPos.align(AnchorAlign.top),
        ),
      )
      .toList();

  buildDockMarkers(List<Dock> docks) {
    _docks = docks;

    return _markers;
  }

  void showDockDetailsModal(NearbyDocksBloc provider) {
    showBarModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return BlocProvider.value(
              value: provider,
              child: Container(
                  height: 500,
                  color: Colors.white,
                  child: BlocBuilder<NearbyDocksBloc, NearByDocksState>(
                      builder: (context, state) {
                    if (state is DockDetailsLoaded) {
                      if (state.bike == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              Text("Failed to load details."),
                            ],
                          ),
                        );
                      }

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Image(
                                image: AssetImage('assets/images/bicycle.png'),
                                width: 200),
                            Text(state.bike!.brand + ' ' + state.bike!.model),
                            if (state.dock.address != null)
                              Text(state.dock.address!),
                            ElevatedButton(
                              child: const Text("Rent"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BikeScannerScreen(
                                    rentalRepository: widget.rentalRepository,
                                    firebaseMessaging: widget.firebaseMessaging,
                                  ),
                                ));
                              },
                            )
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  })));
        });
  }
}
