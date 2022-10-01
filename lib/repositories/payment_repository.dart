import 'package:dio/dio.dart';
import 'package:easybikeshare/models/payment.dart';
import 'package:easybikeshare/repositories/api.dart';

class PaymentRepository {
  var getByRentalIdUrl = '$baseUrl/rental/';

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
