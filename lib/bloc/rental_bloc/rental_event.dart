part of 'rental_bloc.dart';

abstract class RentalEvent extends Equatable {
  const RentalEvent();

  @override
  List<Object> get props => [];
}

class LoadRental extends RentalEvent {
  final String bikeId;

  const LoadRental(this.bikeId);

  @override
  List<Object> get props => [bikeId];
}
