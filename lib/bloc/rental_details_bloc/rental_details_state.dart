part of 'rental_details_bloc.dart';

abstract class RentalDetailsState extends Equatable {
  const RentalDetailsState();

  @override
  List<Object> get props => [];
}

class RentalDetailsInitial extends RentalDetailsState {}

class RentalDetailsLoading extends RentalDetailsState {}

class RentalDetailsLoaded extends RentalDetailsState {
  final Payment payment;

  const RentalDetailsLoaded(this.payment);
}
