import 'package:dio/dio.dart';
import 'package:easybikeshare/models/credit_card.dart';
import 'package:easybikeshare/models/user.dart';
import 'package:easybikeshare/repositories/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  var authUrl = '$baseUrl/auth';
  var usersUrl = '$baseUrl/users';

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

    dio.options.headers["Authorization"] = "Bearer $token";
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('username');
    prefs.remove('token');
  }

  Future<bool> register(String username, String password) async {
    Response response = await dio.post(usersUrl, data: {
      "username": username,
      "password": password,
    });

    return response.statusCode == 201;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('username');
  }

  Future<User> getUser() async {
    try {
      Response response = await dio.get("$usersUrl/me");

      if (response.data != null) {
        return User.fromJson(response.data);
      } else {
        throw Exception();
      }
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> addCreditCard(CreditCard creditCard) async {
    Response response =
        await dio.post("$usersUrl/me/credit-cards", data: creditCard.toJson());

    return response.statusCode == 200;
  }

  Future<bool> removeCreditCard(String creditCardNumber) async {
    Response response =
        await dio.delete("$usersUrl/me/credit-cards/$creditCardNumber");

    return response.statusCode == 200;
  }

  Future<List<CreditCard>> getCreditCards() async {
    Response response = await dio.get("$usersUrl/me/credit-cards");

    try {
      if (response.data != null) {
        List<CreditCard> docks = List<CreditCard>.from(
            response.data.map((model) => CreditCard.fromJson(model)));

        return docks;
      } else {
        return <CreditCard>[];
      }
    } catch (error) {
      return <CreditCard>[];
    }
  }
}
