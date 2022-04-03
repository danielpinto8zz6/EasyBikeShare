import 'package:easybikeshare/bloc/rental_bloc/rental_bloc.dart';
import 'package:easybikeshare/repositories/rental_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RentalScreen extends StatefulWidget {
  final String bikeId;
  final RentalRepository rentalRepository;

  const RentalScreen(
      {Key? key, required this.bikeId, required this.rentalRepository})
      : super(key: key);

  @override
  _RentalScreenState createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (context) {
              return RentalBloc(widget.rentalRepository)
                ..add(LoadRental(widget.bikeId));
            },
            child: BlocListener<RentalBloc, RentalState>(
                listener: (context, state) {},
                child: BlocBuilder<RentalBloc, RentalState>(
                    builder: (context, state) {
                  if (state is RentalLoaded) {
                    return const Text("Rental loaded");
                  }

                  return Container(
                      height: 500,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            CircularProgressIndicator(),
                          ],
                        ),
                      ));
                }))));
  }
}
