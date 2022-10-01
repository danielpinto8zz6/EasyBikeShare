import 'package:dio/dio.dart';
import 'package:easybikeshare/models/feedback.dart';
import 'package:easybikeshare/models/rental.dart';
import 'package:easybikeshare/repositories/api.dart';

class FeedbackRepository {
  var feedbackUrl = '$baseUrl/feedbacks';

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
