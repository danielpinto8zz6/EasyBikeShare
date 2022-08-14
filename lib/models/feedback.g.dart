// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackForm _$FeedbackFormFromJson(Map<String, dynamic> json) => FeedbackForm(
      json['rentalId'] as String,
      json['message'] as String,
      json['rating'] as int,
    );

Map<String, dynamic> _$FeedbackFormToJson(FeedbackForm instance) =>
    <String, dynamic>{
      'rentalId': instance.rentalId,
      'message': instance.message,
      'rating': instance.rating,
    };
