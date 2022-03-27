import 'package:json_annotation/json_annotation.dart';
import 'coordinates.dart';

part 'dock.g.dart';

@JsonSerializable()
class Dock {
  final String id;
  final String? bikeId;
  final Coordinates coordinates;
  final String? address;

  Dock(
      {required this.id,
      required this.bikeId,
      required this.coordinates,
      required this.address});

  factory Dock.fromJson(Map<String, dynamic> json) => _$DockFromJson(json);

  Map<String, dynamic> toJson() => _$DockToJson(this);
}
