import 'package:date_format/date_format.dart';
import 'package:easybikeshare/bloc/rental_history_bloc/rental_history_bloc.dart';
import 'package:easybikeshare/repositories/payment_repository.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:easybikeshare/repositories/travel_repository.dart';
import 'package:easybikeshare/screens/rental/rental_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RentalHistoryScreen extends StatefulWidget {
  final RentalRepository rentalRepository;
  final PaymentRepository paymentRepository;
  final TravelRepository travelRepository;

  const RentalHistoryScreen(
      {Key? key,
      required this.rentalRepository,
      required this.paymentRepository,
      required this.travelRepository})
      : super(key: key);

  @override
  _RentalHistoryScreenState createState() => _RentalHistoryScreenState();
}

class _RentalHistoryScreenState extends State<RentalHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) {
      return RentalHistoryBloc(widget.rentalRepository)
        ..add(const LoadRentalHistory());
    }, child: BlocBuilder<RentalHistoryBloc, RentalHistoryState>(
        builder: (context, state) {
      if (state is RentalHistoryLoaded) {
        return Builder(
          builder: (context) => Scaffold(
              body: ListView.builder(
            itemCount: state.rentals.length,
            itemBuilder: (context, index) {
              var rental = state.rentals[index];
              var startDate = rental.startDate != null
                  ? formatDate(rental.startDate!,
                      [yyyy, '/', mm, '/', dd, ' ', hh, ':', mm])
                  : 'unknown';
              var duration = rental.startDate != null && rental.endDate != null
                  ? rental.endDate!.difference(rental.startDate!).inMinutes
                  : 'unknown';
              return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => RentalDetailsScreen(
                              rental: rental,
                              paymentRepository: widget.paymentRepository,
                              travelRepository: widget.travelRepository),
                        ))
                        .then((value) => setState(() {
                              BlocProvider.of<RentalHistoryBloc>(context).add(
                                const LoadRentalHistory(),
                              );
                            }));
                  },
                  child: Card(
                      child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.bike_scooter),
                        title: Text(startDate),
                        subtitle: Text(
                          '$duration min',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ],
                  )));
            },
          )),
        );
      }

      return Container(
          height: 500,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[CircularProgressIndicator()],
            ),
          ));
    }));
  }
}
