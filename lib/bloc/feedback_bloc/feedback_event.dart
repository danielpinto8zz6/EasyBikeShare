part of 'feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class SubmitFeedback extends FeedbackEvent {
  final FeedbackForm feedback;

  const SubmitFeedback(this.feedback);

  @override
  List<Object> get props => [feedback];
}

class AskFeedback extends FeedbackEvent {}
