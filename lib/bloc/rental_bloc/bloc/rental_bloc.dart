import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:equatable/equatable.dart';

import '../../../models/bike.dart';

part 'rental_event.dart';
part 'rental_state.dart';

class RentalBloc extends Bloc<RentalEvent, RentalState> {
  RentalBloc() : super(RentalInitial()) {
    on<RentalEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
