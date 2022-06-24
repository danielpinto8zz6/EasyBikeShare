// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      json['id'] as String,
      json['username'] as String,
      json['status'] as int,
      (json['duration'] as num?)?.toDouble(),
      (json['value'] as num?)?.toDouble(),
      json['rentalId'] as String,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'status': instance.status,
      'duration': instance.duration,
      'value': instance.value,
      'rentalId': instance.rentalId,
    };
