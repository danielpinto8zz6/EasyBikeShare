import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/payment.dart';
import 'package:easybikeshare/models/travel_event.dart';
import 'package:easybikeshare/repositories/payment_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:equatable/equatable.dart';

part 'rental_details_event.dart';
part 'rental_details_state.dart';

class RentalDetailsBloc extends Bloc<RentalDetailsEvent, RentalDetailsState> {
  final PaymentRepository paymentRepository;
  final TravelRepository travelRepository;

  RentalDetailsBloc(this.paymentRepository, this.travelRepository)
      : super(RentalDetailsInitial()) {
    on<LoadRentalDetails>((event, emit) async {
      var payment = await paymentRepository.getByRentalId(event.rentalId);
      if (payment != null) {
        emit(PaymentLoaded(payment));
      }

      var travelEvents =
          await travelRepository.getTravelEventsByRentalId(event.rentalId);
      if (travelEvents != null) {
        emit(TravelEventsLoaded(travelEvents));
      }
    });
  }
}
