import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/payment.dart';
import 'package:easybikeshare/repositories/payment_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:easybikeshare/models/payment.dart';

part 'rental_details_event.dart';
part 'rental_details_state.dart';

class RentalDetailsBloc extends Bloc<RentalDetailsEvent, RentalDetailsState> {
  final PaymentRepository paymentRepository;

  RentalDetailsBloc(this.paymentRepository) : super(RentalDetailsInitial()) {
    on<LoadRentalDetails>((event, emit) async {
      var payment = await paymentRepository.getByRentalId(event.rentalId);

      if (payment != null) emit(RentalDetailsLoaded(payment));
    });
  }
}
