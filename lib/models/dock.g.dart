// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dock _$DockFromJson(Map<String, dynamic> json) => Dock(
      id: json['id'] as String,
      bikeId: json['bikeId'] as String?,
      coordinates:
          Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$DockToJson(Dock instance) => <String, dynamic>{
      'id': instance.id,
      'bikeId': instance.bikeId,
      'coordinates': instance.coordinates,
      'address': instance.address,
    };
