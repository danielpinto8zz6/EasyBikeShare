import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:equatable/equatable.dart';

part 'rental_event.dart';
part 'rental_state.dart';

class RentalBloc extends Bloc<RentalEvent, RentalState> {
  final RentalRepository rentalRepository;

  Map<String, RentalState> rentalStateMap = {
    'bike-validated': BikeValidated(),
    'bike-unlocked': BikeUnlocked(),
    'bike-reserved': BikeReserved(),
    'bike-validation-failed': BikeValidationFailed(),
    'bike-reservation-failed': BikeReservationFailed(),
    'bike-unlock-failed': BikeUnlockFailed()
  };

  RentalBloc(this.rentalRepository) : super(RentalInitial()) {
    on<LoadRental>((event, emit) async {
      var request = Rental(bikeId: event.bikeId);

      var result = await rentalRepository.createRental(request);

      emit(RentalLoaded(result));
    });

    on<RentalEventReceived>((event, emit) async {
      if (rentalStateMap.containsKey(event.event)) {
        emit(rentalStateMap[event.event]!);
      }
    });
  }
}
