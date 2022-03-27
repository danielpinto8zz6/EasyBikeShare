import 'package:easybikeshare/models/coordinates.dart';
import 'package:dio/dio.dart';
import 'package:easybikeshare/models/dock.dart';

class DockRepository {
  static String mainUrl = "http://192.168.1.199:8099/api";
  var nearByBikesUrl = '$mainUrl/docks/nearby';

  final Dio dio;

  DockRepository({required this.dio});

  Future<List<Dock>> getNearByDocks(
      Coordinates coordinates, double radius, bool onlyAvailable) async {
    Response response = await dio.get(nearByBikesUrl, queryParameters: {
      "coordinates.latitude": coordinates.latitude,
      "coordinates.longitude": coordinates.longitude,
      "radius": radius,
      "onlyAvailable": onlyAvailable
    });

    if (response.data != null) {
      List<Dock> docks =
          List<Dock>.from(response.data.map((model) => Dock.fromJson(model)));

      return docks;
    } else {
      // TODO: handle error
      return <Dock>[];
    }
  }
}
