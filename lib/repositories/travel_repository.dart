import 'package:dio/dio.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/models/travel_event.dart';

class TravelRepository {
  static String mainUrl = 'http://192.168.1.199:8099/api';
  var travelUrl = '$mainUrl/travel';

  final Dio dio;

  TravelRepository({required this.dio});

  Future<Rental> createTravelEvent(TravelEvent travelEvent) async {
    try {
      Response response = await dio.post(travelUrl, data: travelEvent.toJson());

      if (response.data != null) {
        return Rental.fromJson(response.data);
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<TravelEvent>> getTravelEventsByRentalId(String rentalId) async {
    try {
      Response response = await dio.get("$travelUrl/rental/$rentalId");

      if (response.data != null) {
        return (response.data as List)
            .map((x) => TravelEvent.fromJson(x))
            .toList();
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }
}
