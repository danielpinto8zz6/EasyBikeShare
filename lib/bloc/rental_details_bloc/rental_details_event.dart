part of 'rental_details_bloc.dart';

abstract class RentalDetailsEvent extends Equatable {
  const RentalDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadRentalDetails extends RentalDetailsEvent {
  final String rentalId;

  const LoadRentalDetails(this.rentalId);

  @override
  List<Object> get props => [];
}
