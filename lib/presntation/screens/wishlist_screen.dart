import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String? _wishlistResponse;

  @override
  void initState() {
    super.initState();
    print('Fetching wishlist on initState');
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
  print('Token from SharedPreferences: $token');
    if (token == null) {
      setState(() {
        _wishlistResponse = 'No token found. Please login.';
      });
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('http://skilltestflutter.zybotechlab.com/api/wishlist/'),
        headers: {
          'Authorization': 'Bearer $token',

        },
      );
      setState(() {
        _wishlistResponse = 'Status: ${response.statusCode}\nBody: ${response.body}';
      });
      print('Wishlist response: status=${response.statusCode}, body=${response.body}');
    } catch (e) {
      setState(() {
        _wishlistResponse = 'Error fetching wishlist: $e';
      });
      print('Error fetching wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _wishlistResponse == null
            ? const CircularProgressIndicator()
            : SingleChildScrollView(child: Text(_wishlistResponse!)),
      ),
    );
  }
}
