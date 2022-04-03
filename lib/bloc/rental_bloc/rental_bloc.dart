import 'package:bloc/bloc.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:equatable/equatable.dart';

part 'rental_event.dart';
part 'rental_state.dart';

class RentalBloc extends Bloc<RentalEvent, RentalState> {
  final RentalRepository rentalRepository;

  RentalBloc(this.rentalRepository) : super(RentalInitial()) {
    on<LoadRental>((event, emit) async {
      var request = Rental(bikeId: event.bikeId);

      var result = await rentalRepository.createRental(request);

      emit(RentalLoaded(result));
    });
  }
}
