import 'package:flutter/material.dart';
import 'package:zybo_test/presntation/screens/registration_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final String otp;
  final bool isUserExist;

  const OtpScreen({
    super.key,
    required this.phone,
    required this.otp,
    required this.isUserExist,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

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
              "OTP VERIFICATION",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: Color(0xff000000),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Enter the OTP sent to ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
                Text(
                  '+91-${widget.phone} ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "OTP is ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${widget.otp}',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff5E5BE2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (i) => SizedBox(
                  width: 60,
                  child: TextField(
                    controller: otpControllers[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: const InputDecoration(counterText: ""),
                  ),
                ),
              ),
            ),

            // PinCodeTextField(
            //   appContext: context,
            //   length: 4,
            //   controller: otpController,
            //   keyboardType: TextInputType.number,
            //   animationType: AnimationType.fade,
            //   pinTheme: PinTheme(
            //     shape: PinCodeFieldShape.box,
            //     borderRadius: BorderRadius.circular(8),
            //     fieldHeight: 60,
            //     fieldWidth: 60,
            //     activeFillColor: Colors.white,
            //     selectedFillColor: Colors.grey[200],
            //     inactiveFillColor: Colors.grey[200],
            //     inactiveColor: Colors.grey,
            //     activeColor: Colors.deepPurple,
            //     selectedColor: Colors.deepPurple,
            //   ),
            //   animationDuration: const Duration(milliseconds: 300),
            //   enableActiveFill: true,
            //   onCompleted: (value) {
            //     print("OTP Entered: $value");
            //   },
            // ),
            const SizedBox(height: 15),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "00:120 Sec",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 12),
                  const Text.rich(
                    TextSpan(
                      text: "Don’t receive code? ",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Re-send",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final enteredOtp = otpControllers.map((c) => c.text).join();
                  if (enteredOtp == widget.otp) {
                    if (widget.isUserExist) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterScreen(phone: widget.phone),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid OTP")),
                    );
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
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
