import 'package:dio/dio.dart';

class TokenRepository {
  static String mainUrl = "http://192.168.1.199:8099/api";
  var setTokenUrl = '$mainUrl/tokens';
  final Dio dio;

  TokenRepository({required this.dio});

  Future<void> setToken(String username, String token) async {
    await dio.put(setTokenUrl, data: {
      "token": token,
      "key": username,
    });
  }
}
