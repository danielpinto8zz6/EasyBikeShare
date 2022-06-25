import 'package:easybikeshare/models/coordinates.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_event.g.dart';

@JsonSerializable()
class TravelEvent {
  final String rentalId;
  final Coordinates coordinates;

  TravelEvent(this.rentalId, this.coordinates);

  factory TravelEvent.fromJson(Map<String, dynamic> json) =>
      _$TravelEventFromJson(json);

  Map<String, dynamic> toJson() => _$TravelEventToJson(this);
}
