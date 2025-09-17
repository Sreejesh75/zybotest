import 'package:http/http.dart' as http;
import 'dart:convert';

class BannerRepository {
  final String baseUrl = 'https://skilltestflutter.zybotechlab.com/api';

  Future<List> fetchBanners() async {
    final response = await http.get(Uri.parse('$baseUrl/banners/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data is List ? data : [];
    } else {
      throw Exception('Failed to load banners: ${response.statusCode}');
    }
  }
}
