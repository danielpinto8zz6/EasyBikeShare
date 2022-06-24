// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelEvent _$TravelEventFromJson(Map<String, dynamic> json) => TravelEvent(
      json['rentalId'] as String,
      Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
      json['username'] as String,
    );

Map<String, dynamic> _$TravelEventToJson(TravelEvent instance) =>
    <String, dynamic>{
      'rentalId': instance.rentalId,
      'coordinates': instance.coordinates,
      'username': instance.username,
    };
