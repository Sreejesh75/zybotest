import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ProductGrid extends StatelessWidget {
  final List products;
  const ProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(product: product);
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final dynamic product;
  const _ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool wishlisted = false;
  bool loading = false;

  Future<String?> _getBearerToken() async {
    // Retrieve token using the same key as other API calls
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _toggleWishlist(int productId) async {
    setState(() {
      loading = true;
    });
  const String apiUrl = 'https://skilltestflutter.zybotechlab.com/api/add-remove-wishlist/';
    try {
      final token = await _getBearerToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated.')),
        );
        setState(() {
          loading = false;
        });
        return;
      }
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'product_id': productId}),
      );
      debugPrint('Wishlist API response: \\nStatus: \\${response.statusCode}\\nBody: \\${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          wishlisted = !wishlisted;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update wishlist.')),
        );
      }
    } catch (e) {
      debugPrint('Wishlist API error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: const Color(0xFFF7F7FA),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: product.featuredImage != null
                      ? Image.network(product.featuredImage!, fit: BoxFit.cover)
                      : Container(color: Colors.grey[200]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      '₹${product.mrp}',
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '₹${product.salePrice}',
                      style: const TextStyle(
                        color: Color(0xFF2323C7),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Color(0xFFFFA800), size: 18),
                    const SizedBox(width: 4),
                    const Text(
                      '4.5',
                      style: TextStyle(
                        color: Color(0xFF23235B),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF23235B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: loading
                  ? null
                  : () => _toggleWishlist(product.id),
              child: loading
                  ? SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Image.asset(
                      wishlisted
                          ? 'assets/images/wishlisted.png'
                          : 'assets/images/not_wishlisted.png',
                      width: 28,
                      height: 28,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
