import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:totalx_task/view/Auth_screens/otp.dart';

Future<void> submitPhoneNum(
    BuildContext context, TextEditingController phoneNumberController) async {
  String phoneNumber = phoneNumberController.text.trim();

  if (!phoneNumber.startsWith("+91")) {
    phoneNumber = "+91$phoneNumber";
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        log("Verification completed: ${credential.smsCode}");
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        log("Verification failed: ${e.message}");
        if (e.code == 'too-many-requests') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Too many requests. Please try again later."),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Verification failed. Please check the phone number."),
            ),
          );
        }
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        log("Code sent to $phoneNumber");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              verificationid: verificationId,
              phoneNumberController: phoneNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log("Code auto-retrieval timeout");
      },
    );
  } catch (e) {
    log("An error occurred: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("An error occurred. Please try again."),
      ),
    );
  }
}

 
