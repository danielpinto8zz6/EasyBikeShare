import 'package:json_annotation/json_annotation.dart';

part 'bike.g.dart';

@JsonSerializable()
class Bike {
  final String id;
  final String brand;
  final String model;

  Bike({required this.id, required this.brand, required this.model});

  factory Bike.fromJson(Map<String, dynamic> json) => _$BikeFromJson(json);

  Map<String, dynamic> toJson() => _$BikeToJson(this);
}
