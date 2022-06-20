// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rental _$RentalFromJson(Map<String, dynamic> json) => Rental(
      id: json['id'] as String?,
      originDockId: json['originDockId'] as String?,
      destinationDockId: json['destinationDockId'] as String?,
      bikeId: json['bikeId'] as String,
      username: json['username'] as String?,
      status: json['status'] as int?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$RentalToJson(Rental instance) => <String, dynamic>{
      'id': instance.id,
      'originDockId': instance.originDockId,
      'destinationDockId': instance.destinationDockId,
      'bikeId': instance.bikeId,
      'username': instance.username,
      'status': instance.status,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
