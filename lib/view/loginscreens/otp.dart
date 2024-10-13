import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:totalx_task/view/home_page.dart';

class OtpScreen extends StatelessWidget {
  final String? verificationid;
  final String? phoneNumberController;

  OtpScreen({
    super.key,
    this.verificationid,
    this.phoneNumberController,
  });

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  Future<void> _submitotpnum(BuildContext context) async {
    String otp = _otpControllers.map((controller) => controller.text).join();
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationid!,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 250),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/otp_image.png",
                        height: 150,
                        width: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 200),
                        child: const Text(
                          "OTP Verification",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Enter the verification code we just sent to your number ${phoneNumberController.toString()}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 70, 68, 68),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          6,
                          (index) => SizedBox(
                            width: 50,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLength: 1,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    if (index < 5) {
                                      _focusNodes[index].unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_focusNodes[index + 1]);
                                    } else {
                                      _focusNodes[index].unfocus();
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't get OTP? ",
                            style: TextStyle(
                              letterSpacing: 1,
                              color: Color.fromARGB(255, 87, 85, 85),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Resend",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              _submitotpnum(context);
                            },
                            child: const Text(
                              "Verify",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
