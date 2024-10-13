import 'package:flutter/material.dart';
import 'package:totalx_task/service/phone_auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Image.asset(
                    "assets/log-removebg-preview.png",
                    height: 150,
                  ),
                ),
              ),
              const Text(
                "Enter Phone Number",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter Phone Number *",
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 130, 128, 128)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "By Continuing, I agree to TotalX's ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: "Terms and Conditions ",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: "& "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25)),
                child: MaterialButton(
                  onPressed: () {
                    if (_phoneNumberController.text.isNotEmpty) {
                      submitPhoneNum(context, _phoneNumberController);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid phone number."),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Get OTP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
