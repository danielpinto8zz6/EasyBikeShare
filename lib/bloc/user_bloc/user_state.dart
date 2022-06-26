part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);
}

class UserLoadFailure extends UserState {
  final String error;

  const UserLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'UserLoadFailure { error: $error }';
}

class CreditCardSaving extends UserState {}

class CreditCardSaveFailure extends UserState {
  final String error;

  const CreditCardSaveFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CreditCardSaveFailure { error: $error }';
}

class CreditCardSaveSuccess extends UserState {}

class CreditCardRemoveFailure extends UserState {
  final String error;

  const CreditCardRemoveFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CreditCardRemoveFailure { error: $error }';
}

class CreditCardRemoveSuccess extends UserState {}

class CreditCardsLoaded extends UserState {
  final List<CreditCard> creditCards;

  const CreditCardsLoaded(this.creditCards);
}
