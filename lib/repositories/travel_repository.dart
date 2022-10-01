import 'package:dio/dio.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/models/travel_event.dart';
import 'package:easybikeshare/repositories/api.dart';

class TravelRepository {
  var travelUrl = '$baseUrl/travel';

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

  Future<List<TravelEvent>?> getTravelEventsByRentalId(String rentalId) async {
    try {
      Response response = await dio.get("$travelUrl/rental/$rentalId");

      if (response.data != null) {
        return (response.data as List)
            .map((x) => TravelEvent.fromJson(x))
            .toList();
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
