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

class BikeValidated extends RentalState {}

class BikeReserved extends RentalState {}

class BikeUnlocked extends RentalState {}

class BikeLocked extends RentalState {}

class BikeValidationFailed extends RentalState {}

class BikeReservationFailed extends RentalState {}

class BikeUnlockFailed extends RentalState {}
