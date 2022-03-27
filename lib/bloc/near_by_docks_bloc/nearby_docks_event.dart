import 'package:easybikeshare/models/dock.dart';
import 'package:equatable/equatable.dart';

abstract class NearbyDocksEvent extends Equatable {
  const NearbyDocksEvent();
}

class GetNearByDocks extends NearbyDocksEvent {
  const GetNearByDocks();

  @override
  List<Object> get props => [];
}

class LoadUserLocation extends NearbyDocksEvent {
  const LoadUserLocation();

  @override
  List<Object> get props => [];
}

class DockDetailsButtonPressed extends NearbyDocksEvent {
  @override
  List<Object> get props => [];

  final Dock dock;

  const DockDetailsButtonPressed(this.dock);
}
