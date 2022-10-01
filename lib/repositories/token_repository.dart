import 'package:dio/dio.dart';
import 'package:easybikeshare/repositories/api.dart';

class TokenRepository {
  var setTokenUrl = '$baseUrl/tokens';
  final Dio dio;

  TokenRepository({required this.dio});

  Future<void> setToken(String username, String token) async {
    await dio.put(setTokenUrl, data: {
      "token": token,
      "key": username,
    });
  }
}
