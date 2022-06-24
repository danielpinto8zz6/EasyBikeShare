// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCard _$CreditCardFromJson(Map<String, dynamic> json) => CreditCard(
      json['number'] as String,
      json['name'] as String,
      json['code'] as String,
      DateTime.parse(json['validity'] as String),
    );

Map<String, dynamic> _$CreditCardToJson(CreditCard instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'code': instance.code,
      'validity': instance.validity.toIso8601String(),
    };
