import 'package:easybikeshare/models/bike.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class NearByDocksState extends Equatable {
  const NearByDocksState();

  @override
  List<Object> get props => [];
}

class NearByDocksInitial extends NearByDocksState {}

class NearByDocksLoading extends NearByDocksState {}

class NearByDocksLoaded extends NearByDocksState {
  final List<Dock> docks;

  const NearByDocksLoaded({required this.docks});

  @override
  List<Object> get props => [docks];
}

class UserLocationLoaded extends NearByDocksState {
  final Position position;

  const UserLocationLoaded(this.position);

  @override
  List<Object> get props => [position];
}

class NearByDocksFailure extends NearByDocksState {
  final String error;

  const NearByDocksFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'NearByBikesFailure { error: $error }';
}

class DockDetailsLoading extends NearByDocksState {}

class DockDetailsLoaded extends NearByDocksState {
  final Bike? bike;
  final Dock dock;

  const DockDetailsLoaded(this.dock, this.bike);
}
