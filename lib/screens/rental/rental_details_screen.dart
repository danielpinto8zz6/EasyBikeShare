import 'package:date_format/date_format.dart';
import 'package:easybikeshare/bloc/rental_details_bloc/rental_details_bloc.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/repositories/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RentalDetailsScreen extends StatefulWidget {
  final Rental rental;
  final PaymentRepository paymentRepository;

  const RentalDetailsScreen(
      {Key? key, required this.rental, required this.paymentRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RentalDetailsState();
}

class _RentalDetailsState extends State<RentalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text("Rental details"),
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: BlocProvider(create: (context) {
          return RentalDetailsBloc(widget.paymentRepository)
            ..add(LoadRentalDetails(widget.rental.id));
        }, child: BlocBuilder<RentalDetailsBloc, RentalDetailsState>(
            builder: (context, state) {
          if (state is RentalDetailsLoaded) {
            String value = state.payment.value != null
                ? "${state.payment.value}€ "
                : 'NaN';
            String distance = "24km";
            String duration = widget.rental.startDate != null &&
                    widget.rental.endDate != null
                ? "${widget.rental.endDate!.difference(widget.rental.startDate!).inMinutes}min"
                : 'NaN';
            String startDate = widget.rental.startDate != null
                ? formatDate(widget.rental.startDate!,
                    [yyyy, '/', mm, '/', dd, ' ', hh, ':', mm])
                : 'unknown';

            return Builder(builder: (context) {
              return Column(children: [
                Container(
                    // here
                    height: 400,
                    alignment: Alignment.centerLeft,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(51.5, -0.09),
                        zoom: 13.0,
                      ),
                      layers: [
                        TileLayerOptions(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c']),
                      ],
                    )),
                const SizedBox(height: 24),
                const Padding(
                    padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            child: Text(
                          "Route summary",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )))),
                const SizedBox(height: 24),
                Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            child: Row(children: [
                          const Icon(Icons.location_on_outlined),
                          const SizedBox(width: 6),
                          Text(
                            "Distance: $distance",
                            style: const TextStyle(fontSize: 16),
                          )
                        ])))),
                const SizedBox(height: 24),
                Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            child: Row(children: [
                          const Icon(Icons.timer_outlined),
                          const SizedBox(width: 6),
                          Text(
                            "Start date: $startDate",
                            style: const TextStyle(fontSize: 16),
                          )
                        ])))),
                const SizedBox(height: 24),
                Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            child: Row(children: [
                          const Icon(Icons.timelapse),
                          const SizedBox(width: 6),
                          Text(
                            "Duration: $duration",
                            style: const TextStyle(fontSize: 16),
                          )
                        ])))),
                const SizedBox(height: 24),
                Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            child: Row(children: [
                          const Icon(Icons.price_change_outlined),
                          const SizedBox(width: 6),
                          Text(
                            "Cost: $value",
                            style: const TextStyle(fontSize: 16),
                          )
                        ])))),
                const SizedBox(height: 24),
                // Padding(
                //     padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
                //     child: Align(
                //         alignment: Alignment.centerLeft,
                //         child: SizedBox(
                //             child: Row(children: const [
                //           Icon(Icons.reviews_outlined),
                //           SizedBox(width: 6),
                //           Text(
                //             "Classification",
                //             style: TextStyle(fontSize: 16),
                //           )
                //         ]))))
              ]);
            });
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
        })));
  }
}
