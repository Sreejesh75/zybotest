import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text("Let's Connect with Lorem Ipsum..!"),
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

                      // print OTP in console
                      print("📩 OTP is: ${data['otp']}");

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

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => OtpScreen(
                  //       phone: phoneController.text,
                  //       otp: data['otp'].toString(), // mock OTP, later replace with API
                  //       isUserExist: data['isUserExist'],
                  //     ),
                  //   ),
                  // );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),

            const Center(
              child: Text.rich(
                TextSpan(
                  text: "By Continuing you accepting the ",
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
