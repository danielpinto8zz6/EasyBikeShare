part of 'rental_bloc.dart';

abstract class RentalState extends Equatable {
  const RentalState();

  @override
  List<Object> get props => [];
}

class RentalInitial extends RentalState {}

class RentalLoading extends RentalState {}

class RentalLoaded extends RentalState {
  final Rental rental;

  const RentalLoaded(this.rental);
}
