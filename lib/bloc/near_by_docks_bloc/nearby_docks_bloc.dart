import 'package:easybikeshare/models/coordinates.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:easybikeshare/models/dock_status.dart';
import 'package:easybikeshare/repositories/bike_repository.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'nearby_docks_event.dart';
import 'nearby_docks_state.dart';

class NearbyDocksBloc extends Bloc<NearbyDocksEvent, NearByDocksState> {
  final DockRepository dockRepository;
  final MapController mapController;
  final BikeRepository bikeRepository;
  final locationHandler = Location();

  NearbyDocksBloc(
      {required this.dockRepository,
      required this.mapController,
      required this.bikeRepository})
      : super(NearByDocksInitial()) {
    on<LoadUserLocation>((event, emit) async {
      final position = await locationHandler.getLocation();

      if (position.latitude != null && position.longitude != null) {
        mapController.move(LatLng(position.latitude!, position.longitude!), 16);

        emit(UserLocationLoaded(position));
      }
    });

    on<GetNearByDocks>((event, emit) async {
      emit(NearByDocksLoading());

      final position = await locationHandler.getLocation();

      if (position.latitude != null && position.longitude != null) {
        mapController.move(LatLng(position.latitude!, position.longitude!), 16);

        try {
          final coordinates = Coordinates(
              latitude: position.latitude!, longitude: position.longitude!);

          final List<Dock> docks = await dockRepository.getNearByDocks(
              coordinates, 100, DockStatus.withBike);

          emit(NearByDocksLoaded(docks: docks));
        } catch (_) {
          emit(NearByDocksLoaded(docks: List<Dock>.empty()));
        }
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
}
