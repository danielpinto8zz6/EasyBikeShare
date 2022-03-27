part of 'rental_bloc.dart';

abstract class RentalEvent extends Equatable {
  const RentalEvent();

  @override
  List<Object> get props => [];
}

class RentalButtonPressed extends RentalEvent {
  final Dock dock;
  final Bike bike;

  const RentalButtonPressed(this.dock, this.bike);

  @override
  List<Object> get props => [dock, bike];
}
