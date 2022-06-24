import 'package:easybikeshare/models/credit_card.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String username;
  final String? name;
  final List<CreditCard> creditCards;

  User(this.username, this.name, this.creditCards);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
