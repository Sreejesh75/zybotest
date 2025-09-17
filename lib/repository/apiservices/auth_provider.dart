import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthProvider {
  final String baseUrl = "https://skilltestflutter.zybotechlab.com/api";

  /// Verify user by phone number
  Future<Map<String, dynamic>> verifyUser(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify/'),
      body: {'phone_number': phone},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Failed to verify user: ${response.body}");
    }
  }

  /// Login/Register user
  Future<Map<String, dynamic>> loginRegister(
    String phone,
    String firstName,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login-register/'),
      body: {'phone_number': phone, 'first_name': firstName},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Failed to login/register: ${response.body}");
    }
  }
}
