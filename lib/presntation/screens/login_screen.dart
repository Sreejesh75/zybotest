import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Let’s Connect with Lorem Ipsum..!",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w400,
                color: Color(0xff4E4D4D),
              ),
            ),
            const SizedBox(height: 30),

            // Phone Input
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixText: "+91 ",
                labelText: "Enter Phone",

                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final phone = phoneController.text.trim();
                  if (phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("please enter phone number "),
                      ),
                    );
                    return;
                  }
                  try {
                    final response = await http.post(
                      Uri.parse(
                        "https://skilltestflutter.zybotechlab.com/api/verify/",
                      ),
                      body: {"phone_number": phone},
                    );

                    if (response.statusCode == 200) {
                      final data = json.decode(response.body);
                      print(data);
                      // Save token and user id if present
                      if (data["token"] != null &&
                          data["token"]["access"] != null) {
                        // Save access token and user id to SharedPreferences
                        // ignore: use_build_context_synchronously
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('token', data["token"]["access"]);
                        if (data["token"]["user_id"] != null) {
                          await prefs.setString(
                            'user_id',
                            data["token"]["user_id"].toString(),
                          );
                        }
                      }
                      // print OTP in console
                      print("\ud83d\udce9 OTP is: {data['otp']}");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OtpScreen(
                            phone: phone,
                            otp: data['otp'].toString(), // API OTP
                            isUserExist: data['user'], // true / false
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to send OTP")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffFFFFFF),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Center(
              child: Text.rich(
                TextSpan(
                  text: "By Continuing you accepting the ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                  ),
                  children: [
                    TextSpan(
                      text: "Terms of Use & Privacy Policy",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
