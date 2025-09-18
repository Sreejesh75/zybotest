import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zybo_test/data/models/user_model.dart';

class ProfileRepository {
  final String baseUrl = "http://skilltestflutter.zybotechlab.com";

  Future<Profile> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access");

    final response = await http.get(
      Uri.parse("$baseUrl/user-data/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Profile.fromJson(data);
    } else {
      throw Exception("Failed to load profile");
    }
  }
}
