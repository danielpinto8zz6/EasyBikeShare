import 'package:easybikeshare/models/coordinates.dart';
import 'package:dio/dio.dart';
import 'package:easybikeshare/models/dock.dart';
import 'package:easybikeshare/models/dock_status.dart';
import 'package:easybikeshare/repositories/api.dart';

class DockRepository {
  var nearByBikesUrl = '$baseUrl/docks/nearby';
  var getByBikeIdUrl = '$baseUrl/docks/bike/';

  final Dio dio;

  DockRepository({required this.dio});

  Future<List<Dock>> getNearByDocks(
      Coordinates coordinates, double radius, DockStatus dockStatus) async {
    Response response = await dio.get(nearByBikesUrl, queryParameters: {
      "coordinates.latitude": coordinates.latitude,
      "coordinates.longitude": coordinates.longitude,
      "radius": radius,
      "filterStatus": dockStatus.index
    });

    if (response.data != null) {
      List<Dock> docks =
          List<Dock>.from(response.data.map((model) => Dock.fromJson(model)));

      return docks;
    } else {
      return <Dock>[];
    }
  }

  Future<Dock?> getDockByBikeId(String bikeId) async {
    Response response = await dio.get(getByBikeIdUrl + bikeId);

    if (response.data != null) {
      Dock dock = Dock.fromJson(response.data);

      return dock;
    } else {
      return null;
    }
  }
}
