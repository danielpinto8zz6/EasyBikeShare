import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class FeedbackForm {
  final String rentalId;
  final String message;
  final int rating;

  FeedbackForm(this.rentalId, this.message, this.rating);

  factory FeedbackForm.fromJson(Map<String, dynamic> json) =>
      _$FeedbackFormFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackFormToJson(this);
}
