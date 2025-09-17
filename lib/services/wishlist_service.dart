import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WishlistService {
  static const String _wishlistKey = "wishlist_products";

  // Save product (full object as JSON)
  static Future<void> addToWishlist(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = prefs.getStringList(_wishlistKey) ?? [];

    // convert product map to string
    final productString = jsonEncode(product);

    if (!wishlist.contains(productString)) {
      wishlist.add(productString);
      await prefs.setStringList(_wishlistKey, wishlist);
    }
  }

  // Remove product by id
  static Future<void> removeFromWishlist(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = prefs.getStringList(_wishlistKey) ?? [];

    wishlist.removeWhere((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == productId;
    });

    await prefs.setStringList(_wishlistKey, wishlist);
  }

  // Get wishlist (decoded list of products)
  static Future<List<Map<String, dynamic>>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = prefs.getStringList(_wishlistKey) ?? [];
    return wishlist
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  // Clear wishlist
  static Future<void> clearWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wishlistKey);
  }
}
