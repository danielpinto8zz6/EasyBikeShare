part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUser extends UserEvent {
  const LoadUser();

  @override
  List<Object> get props => [];
}

class SaveCreditCard extends UserEvent {
  final CreditCard creditCard;

  const SaveCreditCard(this.creditCard);

  @override
  List<Object> get props => [];
}

class RemoveCreditCard extends UserEvent {
  final String creditCardNumber;

  const RemoveCreditCard(this.creditCardNumber);

  @override
  List<Object> get props => [];
}

class GetCreditCards extends UserEvent {
  @override
  List<Object> get props => [];
}
