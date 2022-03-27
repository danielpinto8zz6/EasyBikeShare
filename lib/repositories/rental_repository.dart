import 'package:dio/dio.dart';
import 'package:easybikeshare/models/rental.dart';

class RentalRepository {
  static String mainUrl = "http://192.168.1.199:8099/api";
  var createRentalUrl = 'http://192.168.1.199:5020/api/Rental/';

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
}
