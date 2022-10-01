import 'package:dio/dio.dart';
import 'package:easybikeshare/models/bike.dart';
import 'package:easybikeshare/repositories/api.dart';

class BikeRepository {
  var bikeByIdUrl = '$baseUrl/Bikes/';

  final Dio dio;

  BikeRepository({required this.dio});

  Future<Bike> getBikeById(String bikeId) async {
    try {
      Response response = await dio.get(bikeByIdUrl + bikeId);

      if (response.data != null) {
        return Bike.fromJson(response.data);
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }
}
