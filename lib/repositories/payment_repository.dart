import 'package:dio/dio.dart';
import 'package:easybikeshare/models/payment.dart';

class PaymentRepository {
  static String mainUrl = "http://192.168.1.199:8099/api/payments";
  var getByRentalIdUrl = '$mainUrl/rental/';

  final Dio dio;

  PaymentRepository({required this.dio});

  Future<Payment?> getByRentalId(String rentalId) async {
    try {
      Response response = await dio.get(getByRentalIdUrl + rentalId);

      if (response.data != null) {
        var payment = Payment.fromJson(response.data);

        return payment;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
