import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'rental_history_event.dart';
part 'rental_history_state.dart';

class RentalHistoryBloc extends Bloc<RentalHistoryEvent, RentalHistoryState> {
  final RentalRepository rentalRepository;

  RentalHistoryBloc(this.rentalRepository) : super(RentalHistoryInitial()) {
    on<LoadRentalHistory>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username');

      if (username != null) {
        var rentals =
            await rentalRepository.getRentalHistoryByUsername(username);

        emit(RentalHistoryLoaded(rentals));
      }
    });
  }
}
