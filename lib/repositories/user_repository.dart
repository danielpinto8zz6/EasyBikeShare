import 'package:dio/dio.dart';
import 'package:easybikeshare/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static String mainUrl = "http://192.168.1.199:8099/api";
  var authUrl = '$mainUrl/auth';
  var registerUrl = '$mainUrl/users';
  var userUrl = '$mainUrl/users/';

  final Dio dio;

  UserRepository({required this.dio});

  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();

    var value = prefs.getString('token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);

    dio.options.headers["Authorization"] = "Bearer " + token;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('token');
  }

  Future<void> persistUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', username);
  }

  Future<void> deleteUsername() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('username');
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

    return response.statusCode == 201;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('username');
  }

  Future<User> getUserByUsername(String username) async {
    try {
      Response response = await dio.get(userUrl + username);

      if (response.data != null) {
        return User.fromJson(response.data);
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }
}
