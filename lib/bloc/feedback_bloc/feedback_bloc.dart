import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/feedback.dart';
import 'package:easybikeshare/repositories/feedback_repository.dart';
import 'package:equatable/equatable.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository feedbackRepository;

  FeedbackBloc(this.feedbackRepository) : super(FeedbackInitial()) {
    on<AskFeedback>((event, emit) async {
      emit(WaitingFeedback());
    });
    on<SubmitFeedback>((event, emit) async {
      await feedbackRepository.createFeedback(event.feedback);
    });
  }
}
