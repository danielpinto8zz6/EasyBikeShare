import 'package:easybikeshare/models/rental.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RentalDetailsScreen extends StatefulWidget {
  final Rental rental;

  const RentalDetailsScreen({Key? key, required this.rental}) : super(key: key);

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
      body: Builder(builder: (context) {
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )))),
          const SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      child: Row(children: const [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 6),
                    Text(
                      "Distance",
                      style: TextStyle(fontSize: 16),
                    )
                  ])))),
          const SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      child: Row(children: const [
                    Icon(Icons.timer_outlined),
                    SizedBox(width: 6),
                    Text(
                      "Duration",
                      style: TextStyle(fontSize: 16),
                    )
                  ])))),
          const SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      child: Row(children: const [
                    Icon(Icons.price_change_outlined),
                    SizedBox(width: 6),
                    Text(
                      "Cost",
                      style: TextStyle(fontSize: 16),
                    )
                  ])))),
          const SizedBox(height: 24),
          Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      child: Row(children: const [
                    Icon(Icons.reviews_outlined),
                    SizedBox(width: 6),
                    Text(
                      "Classification",
                      style: TextStyle(fontSize: 16),
                    )
                  ]))))
        ]);
      }),
    );
  }
}
