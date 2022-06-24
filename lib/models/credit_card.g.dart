// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCard _$CreditCardFromJson(Map<String, dynamic> json) => CreditCard(
      json['cardNumber'] as String,
      json['cardHolderName'] as String,
      json['cvvCode'] as String,
      json['expiryDate'] as String,
    );

Map<String, dynamic> _$CreditCardToJson(CreditCard instance) =>
    <String, dynamic>{
      'cardNumber': instance.cardNumber,
      'cardHolderName': instance.cardHolderName,
      'cvvCode': instance.cvvCode,
      'expiryDate': instance.expiryDate,
    };
