part of 'rental_details_bloc.dart';

abstract class RentalDetailsState extends Equatable {
  const RentalDetailsState();

  @override
  List<Object> get props => [];
}

class RentalDetailsInitial extends RentalDetailsState {}

class RentalDetailsLoading extends RentalDetailsState {}

class PaymentLoaded extends RentalDetailsState {
  final Payment payment;

  const PaymentLoaded(this.payment);
}

class TravelEventsLoaded extends RentalDetailsState {
  final List<TravelEvent> travelEvents;

  const TravelEventsLoaded(this.travelEvents);
}
