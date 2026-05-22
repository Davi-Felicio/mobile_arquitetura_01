import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_user.dart';

class AuthService {
  static const _baseUrl = "https://dummyjson.com/auth/login";

  Future<AuthUser> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "expiresInMins": 30,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Credenciais inválidas");
    }
    return AuthUser.fromJson(jsonDecode(response.body));
  }
}
