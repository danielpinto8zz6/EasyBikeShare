import 'package:easybikeshare/models/coordinates.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:easybikeshare/repositories/bike_repository.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'nearby_docks_event.dart';
import 'nearby_docks_state.dart';

class NearbyDocksBloc extends Bloc<NearbyDocksEvent, NearByDocksState> {
  final DockRepository dockRepository;
  final MapController mapController;
  final BikeRepository bikeRepository;

  NearbyDocksBloc(
      {required this.dockRepository,
      required this.mapController,
      required this.bikeRepository})
      : super(NearByDocksInitial()) {
    on<LoadUserLocation>((event, emit) async {
      final position = await _determinePosition();

      mapController.move(LatLng(position.latitude, position.longitude), 16);

      emit(UserLocationLoaded(position));
    });

    on<GetNearByDocks>((event, emit) async {
      emit(NearByDocksLoading());

      final position = await _determinePosition();

      mapController.move(LatLng(position.latitude, position.longitude), 16);

      try {
        final coordinates = Coordinates(
            latitude: position.latitude, longitude: position.longitude);

        final List<Dock> docks =
            await dockRepository.getNearByDocks(coordinates, 100, false);

        emit(NearByDocksLoaded(docks: docks));
      } catch (_) {
        emit(const NearByDocksFailure(error: "Failed to load"));
      }
    });

    on<DockDetailsButtonPressed>((event, emit) async {
      emit(DockDetailsLoading());

      try {
        final bike = await bikeRepository.getBikeById(event.dock.bikeId!);
        emit(DockDetailsLoaded(event.dock, bike));
      } catch (error) {
        rethrow;
      }
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
