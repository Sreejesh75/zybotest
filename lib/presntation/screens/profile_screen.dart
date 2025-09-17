import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? phoneNumber;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('ProfileScreen mounted: $mounted');
    print('Profile API URL: http://skilltestflutter.zybotechlab.com/api/user-data/');
    print('Token from SharedPreferences: $token');
    print('Token length: [32m${token?.length}[0m');
    if (token == null) {
      setState(() {
        error = 'No token found. Please login.';
      });
      print('ERROR: No token found in SharedPreferences.');
      return;
    }
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      print('Profile API headers: $headers');
      final response = await http.get(
        Uri.parse('http://skilltestflutter.zybotechlab.com/api/user-data/'),
        headers: headers,
      );
      print('Profile API response status: ${response.statusCode}');
      print('Profile API response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['name']?.toString();
          phoneNumber = data['phone_number']?.toString();
          error = null;
        });
        print('Profile fetch success: name=$name, phone=$phoneNumber');
      } else {
        setState(() {
          error = 'Failed to fetch profile: \u001b[31m${response.statusCode}\n${response.body}\u001b[0m';
        });
        print('Failed to fetch profile: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching profile: $e';
      });
      print('Exception in fetchProfile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Information'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Do you want to Logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              if (shouldLogout == true) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                await prefs.remove('user_id');
                if (mounted) {
                  setState(() {
                    name = null;
                    phoneNumber = null;
                    error = 'Logged out. Please login again.';
                  });
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: error != null
            ? Text(error!, style: const TextStyle(color: Colors.red))
            : (name == null || phoneNumber == null)
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: $name', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text(
                    'Phone: $phoneNumber',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
      ),
    );
  }
}
