import 'dart:async';

import 'package:easybikeshare/bloc/feedback_bloc/feedback_bloc.dart';
import 'package:easybikeshare/models/feedback.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/repositories/feedback_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rating_dialog/rating_dialog.dart';

class FeedbackScreen extends StatefulWidget {
  final String rentalId;
  final FeedbackRepository feedbackRepository;
  final DockRepository dockRepository;
  final RentalRepository rentalRepository;

  const FeedbackScreen(
      {Key? key,
      required this.rentalId,
      required this.feedbackRepository,
      required this.dockRepository,
      required this.rentalRepository})
      : super(key: key);

  @override
  FeedbackScreenState createState() => FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen> {
  late final FeedbackBloc bloc;

  @override
  void initState() {
    bloc = FeedbackBloc(widget.feedbackRepository);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (context) => bloc..add(AskFeedback()),
            child: BlocConsumer<FeedbackBloc, FeedbackState>(
                listener: (BuildContext context, state) {
              if (state is WaitingFeedback) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  var dialog = RatingDialog(
                    initialRating: 1.0,
                    // your app's name?
                    title: const Text(
                      'Feedback',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // encourage your user to leave a high rating?
                    message: const Text(
                      'Tap a star to set your rating. Add more description here if you want.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    // your app's logo?
                    image: const Image(
                        image: AssetImage('assets/images/bicycle.png'),
                        width: 150),
                    submitButtonText: 'Submit',
                    commentHint: 'Set your custom comment hint',
                    onCancelled: () => Navigator.of(context).pop(),
                    onSubmitted: (response) {
                      var feedback = FeedbackForm(widget.rentalId,
                          response.comment, response.rating.toInt());

                      bloc.add(SubmitFeedback(feedback));

                      Navigator.of(context).pop();
                    },
                  );

                  showDialog(
                    context: context,
                    barrierDismissible:
                        true, // set to false if you want to force a rating
                    builder: (context) => dialog,
                  );
                });
              }
            }, builder: (context, state) {
              return Container();
            })));
  }
}
