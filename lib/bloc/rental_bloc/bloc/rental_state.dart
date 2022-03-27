part of 'rental_bloc.dart';

abstract class RentalState extends Equatable {
  const RentalState();
  
  @override
  List<Object> get props => [];
}

class RentalInitial extends RentalState {}
