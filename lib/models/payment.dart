import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final String id;
  final String username;
  final int status;
  final double? duration;
  final double? value;
  final String rentalId;

  Payment(this.id, this.username, this.status, this.duration, this.value,
      this.rentalId);

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
