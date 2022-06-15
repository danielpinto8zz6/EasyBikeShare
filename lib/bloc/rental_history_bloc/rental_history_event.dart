part of 'rental_history_bloc.dart';

abstract class RentalHistoryEvent extends Equatable {
  const RentalHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadRentalHistory extends RentalHistoryEvent {
  const LoadRentalHistory();

  @override
  List<Object> get props => [];
}
