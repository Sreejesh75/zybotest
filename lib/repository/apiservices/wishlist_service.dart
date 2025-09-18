import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/wishlist_product.dart';

class WishlistService {
  static const String _wishlistUrl = 'https://skilltestflutter.zybotechlab.com/api/wishlist/';
  static const String _toggleUrl = 'https://skilltestflutter.zybotechlab.com/api/add-remove-wishlist/';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<WishlistProduct>> fetchWishlist() async {
    final token = await _getToken();
    if (token == null) throw Exception('No token found');
    final response = await http.get(
      Uri.parse(_wishlistUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((p) => WishlistProduct.fromJson(p)).toList();
    } else {
      throw Exception('Failed to fetch wishlist: ${response.statusCode}');
    }
  }

  Future<bool> toggleWishlist(int productId) async {
    final token = await _getToken();
    if (token == null) throw Exception('No token found');
    final response = await http.post(
      Uri.parse(_toggleUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'product_id': productId}),
    );
  return response.statusCode == 200 || response.statusCode == 201;
  }
}
