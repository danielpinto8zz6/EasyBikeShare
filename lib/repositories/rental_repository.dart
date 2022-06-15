import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easybikeshare/models/rental.dart';

class RentalRepository {
  static String mainUrl = 'http://192.168.1.199:8099/api';
  var createRentalUrl = '$mainUrl/rentals/';
  var rentalHistoryUrl = '$mainUrl/rentals/history/';

  final Dio dio;

  RentalRepository({required this.dio});

  Future<Rental> createRental(Rental rental) async {
    try {
      Response response =
          await dio.post(createRentalUrl, data: {rental.toJson()});

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
