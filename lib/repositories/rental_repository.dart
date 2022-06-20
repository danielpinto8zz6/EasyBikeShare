import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/repositories/dock_repository.dart';

class RentalRepository {
  static String mainUrl = 'http://192.168.1.199:8099/api';
  var createRentalUrl = '$mainUrl/rentals';
  var rentalHistoryUrl = '$mainUrl/rentals/history/';

  final Dio dio;
  final DockRepository dockRepository;

  RentalRepository({required this.dio, required this.dockRepository});

  Future<Rental> createRental(String bikeId, String? dockId) async {
    try {
      if (dockId == null) {
        Dock? dock = await dockRepository.getDockByBikeId(bikeId);
        dockId = dock?.id;
      }

      Response response = await dio.post(createRentalUrl,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode({"originDockId": dockId, "bikeId": bikeId}));

      if (response.data != null) {
        return Rental.fromJson(response.data);
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<Rental>> getRentalHistoryByUsername(String username) async {
    try {
      Response response = await dio.get(rentalHistoryUrl + username);

      if (response.data != null) {
        return (response.data as List).map((x) => Rental.fromJson(x)).toList();
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }
}
