import 'package:json_annotation/json_annotation.dart';

part 'credit_card.g.dart';

@JsonSerializable()
class CreditCard {
  String cardNumber;
  String cardHolderName;
  String cvvCode;
  String expiryDate;

  CreditCard(
      this.cardNumber, this.cardHolderName, this.cvvCode, this.expiryDate);

  factory CreditCard.fromJson(Map<String, dynamic> json) =>
      _$CreditCardFromJson(json);

  Map<String, dynamic> toJson() => _$CreditCardToJson(this);
}
