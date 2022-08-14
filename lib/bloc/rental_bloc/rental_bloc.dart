import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/feedback.dart';
import 'package:easybikeshare/models/coordinates.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:easybikeshare/models/dock_status.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/repositories/feedback_repository.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

part 'rental_event.dart';
part 'rental_state.dart';

class RentalBloc extends Bloc<RentalEvent, RentalState> {
  final RentalRepository rentalRepository;
  final DockRepository dockRepository;
  final locationHandler = Location();
  final FeedbackRepository feedbackRepository;

  Map<String, RentalState> rentalStateMap = {
    'bike-validated': BikeValidated(),
    'bike-reserved': BikeReserved(),
    'bike-attached': BikeAttached(),
    'bike-validation-failed': BikeValidationFailed(),
    'bike-reservation-failed': BikeReservationFailed(),
    'bike-unlock-failed': BikeUnlockFailed()
  };

  RentalBloc(
      this.rentalRepository, this.dockRepository, this.feedbackRepository)
      : super(RentalInitial()) {
    on<LoadRental>((event, emit) async {
      var result = await rentalRepository.createRental(event.bikeId, null);

      emit(RentalAccepted(result));
    });

    on<RentalEventReceived>((event, emit) async {
      if (rentalStateMap.containsKey(event.event)) {
        emit(rentalStateMap[event.event]!);
      }

      if (event.event == 'bike-unlocked') {
        final position = await locationHandler.getLocation();

        if (position.latitude != null && position.longitude != null) {
          try {
            final coordinates = Coordinates(
                latitude: position.latitude!, longitude: position.longitude!);

            final List<Dock> docks = await dockRepository.getNearByDocks(
                coordinates, 100, DockStatus.withBike);

            emit(BikeUnlocked(docks: docks));
          } catch (_) {
            emit(BikeUnlocked(docks: List<Dock>.empty()));
          }
        }
      }
    });

    on<SubmitFeedback>((event, emit) async {
      await feedbackRepository.createFeedback(event.feedback);
    });
  }
}
