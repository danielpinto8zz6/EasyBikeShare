import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  static String mainUrl = "http://192.168.1.199:8099/api";
  var authUrl = '$mainUrl/auth';
  var registerUrl = '$mainUrl/users';

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Dio dio;

  UserRepository({required this.dio});

  Future<bool> hasToken() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> persistToken(String token) async {
    await storage.write(key: 'token', value: token);
    dio.options.headers["Authorization"] = "Bearer " + token;
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    storage.delete(key: 'token');
  }

  Future<void> persistUsername(String username) async {
    await storage.write(key: 'username', value: username);
  }

  Future<void> deleteUsername() async {
    storage.delete(key: 'username');
  }

  Future<String> login(String username, String password) async {
    Response response = await dio.post(authUrl, data: {
      "username": username,
      "password": password,
    });

    return response.data["token"];
  }

  Future<bool> register(String username, String password) async {
    Response response = await dio.post(registerUrl, data: {
      "username": username,
      "password": password,
    });

    return response.statusCode == 200;
  }

  Future<String?> getUsername() async {
    var username = await storage.read(key: 'username');

    return username;
  }
}
