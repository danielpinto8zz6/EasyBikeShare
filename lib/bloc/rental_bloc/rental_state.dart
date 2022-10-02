part of 'rental_bloc.dart';

abstract class RentalState extends Equatable {
  const RentalState();

  @override
  List<Object> get props => [];
}

class RentalInitial extends RentalState {}

class RentalLoading extends RentalState {}

class RentalAccepted extends RentalState {
  final Rental rental;

  const RentalAccepted(this.rental);
}

class NearByDocksLoaded extends RentalState {
  final List<Dock> docks;

  const NearByDocksLoaded(this.docks);

  @override
  List<Object> get props => [docks];
}

class BikeUnlocked extends RentalState {}

class BikeLocked extends RentalState {}

class RentalFailed extends RentalState {}
