import 'package:dio/dio.dart';
import 'package:easybikeshare/models/bike.dart';

class BikeRepository {
  static String mainUrl = "http://192.168.1.199:8099/api";
  var bikeByIdUrl = 'http://192.168.1.199:5020/api/Bikes/';

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
