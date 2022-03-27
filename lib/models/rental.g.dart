// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rental _$RentalFromJson(Map<String, dynamic> json) => Rental(
      json['id'] as String?,
      json['dockId'] as String,
      json['bikeId'] as String,
      json['username'] as String,
      json['status'] as int?,
      json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$RentalToJson(Rental instance) => <String, dynamic>{
      'id': instance.id,
      'dockId': instance.dockId,
      'bikeId': instance.bikeId,
      'username': instance.username,
      'status': instance.status,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
