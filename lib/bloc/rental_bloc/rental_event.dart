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

class SubmitFeedback extends RentalEvent {
  final FeedbackForm feedback;

  const SubmitFeedback(this.feedback);

  @override
  List<Object> get props => [feedback];
}

class RentalEventReceived extends RentalEvent {
  final String event;

  const RentalEventReceived(this.event);

  @override
  List<Object> get props => [event];
}
