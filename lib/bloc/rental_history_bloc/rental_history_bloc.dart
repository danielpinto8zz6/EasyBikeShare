import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:equatable/equatable.dart';

part 'rental_history_event.dart';
part 'rental_history_state.dart';

class RentalHistoryBloc extends Bloc<RentalHistoryEvent, RentalHistoryState> {
  final RentalRepository rentalRepository;

  RentalHistoryBloc(this.rentalRepository) : super(RentalHistoryInitial()) {
    on<LoadRentalHistory>((event, emit) async {
      var rentals = await rentalRepository.getRentals();

      emit(RentalHistoryLoaded(rentals));
    });
  }
}
