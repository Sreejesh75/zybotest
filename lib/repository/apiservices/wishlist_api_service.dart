import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistApiService {
  static const String _baseUrl = 'http://skilltestflutter.zybotechlab.com/api';

  // Fetch wishlist items
  static Future<List<Product>> fetchWishlist() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/wishlist/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to fetch wishlist');
    }
  }

  // Add or remove product from wishlist
  static Future<void> toggleWishlist(int productId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/add-remove-wishlist/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'product_id': productId}),
    );
    if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode != 200) {
      throw Exception('Failed to update wishlist');
    }
  }

  // Helper to get token from SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
