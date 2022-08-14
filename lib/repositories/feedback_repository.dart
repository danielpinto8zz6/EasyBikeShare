import 'package:dio/dio.dart';
import 'package:easybikeshare/models/feedback.dart';
import 'package:easybikeshare/models/rental.dart';

class FeedbackRepository {
  static String mainUrl = 'http://192.168.1.199:8099/api';
  var feedbackUrl = '$mainUrl/feedbacks';

  final Dio dio;

  FeedbackRepository({required this.dio});

  Future<Rental> createFeedback(FeedbackForm feedback) async {
    try {
      Response response = await dio.post(feedbackUrl, data: feedback.toJson());

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
