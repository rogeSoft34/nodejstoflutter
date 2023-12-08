import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const baseUrl = "http://192.168.1.47:3000/api/";

  static Future<String?> login(Map<String, dynamic> credentials) async {
    final url = Uri.parse('$baseUrl/user/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];

      // Token'ı saklamak için SharedPreferences kullanabilirsiniz.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);

      return token;
    } else {
      throw Exception('Giriş başarısız.');
    }
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}