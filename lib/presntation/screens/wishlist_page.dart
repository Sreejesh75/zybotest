import 'package:flutter/material.dart';
import 'package:zybo_test/services/wishlist_service.dart';
import 'package:zybo_test/data/models/product_model.dart';
import 'package:zybo_test/repository/apiservices/product_repository.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Product> wishlistProducts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final ids = await WishlistService.getWishlist();
    final repo = ProductRepository();
    final allProducts = await repo.fetchProducts(); // get all products from API

    setState(() {
      wishlistProducts = allProducts
          .where((product) => ids.contains(product.id))
          .toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            color: Color(0xFF23235B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF23235B)),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : wishlistProducts.isEmpty
          ? const Center(child: Text('Your wishlist is empty.'))
          : Padding(padding: const EdgeInsets.all(8.0)),
    );
  }
}
