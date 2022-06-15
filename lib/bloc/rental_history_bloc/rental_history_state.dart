part of 'rental_history_bloc.dart';

abstract class RentalHistoryState extends Equatable {
  const RentalHistoryState();

  @override
  List<Object> get props => [];
}

class RentalHistoryInitial extends RentalHistoryState {}

class RentalHistoryLoading extends RentalHistoryState {}

class RentalHistoryLoaded extends RentalHistoryState {
  final List<Rental> rentals;

  const RentalHistoryLoaded(this.rentals);
}
