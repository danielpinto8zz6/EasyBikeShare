import 'package:json_annotation/json_annotation.dart';

part 'rental.g.dart';

@JsonSerializable()
class Rental {
  final String? id;
  final String dockId;
  final String bikeId;
  final String username;
  final int? status;
  final DateTime? startDate;
  final DateTime? endDate;

  Rental(this.id, this.dockId, this.bikeId, this.username, this.status,
      this.startDate, this.endDate);

  factory Rental.fromJson(Map<String, dynamic> json) => _$RentalFromJson(json);

  Map<String, dynamic> toJson() => _$RentalToJson(this);
}
