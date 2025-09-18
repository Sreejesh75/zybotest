import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zybo_test/data/models/product_model.dart';

class ProductRepository {
  final String baseUrl = 'http://skilltestflutter.zybotechlab.com/api';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data.map((e) => Product.fromJson(e)).toList();
      } else if (data['products'] is List) {
        return (data['products'] as List)
            .map((e) => Product.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
