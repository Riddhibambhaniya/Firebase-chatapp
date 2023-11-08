import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? validateEmail(String? value) {
    // Your email validation logic
  }

  String? validatePassword(String? value) {
    // Your password validation logic
  }

  Future<void> signIn() async {
    if (validateEmail(email.value) == null && validatePassword(password.value) == null) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: email.value,
          password: password.value,
        );
        // Authentication successful, you can navigate to the home screen
        Get.toNamed('/home');
      } catch (e) {
        // Handle authentication errors, e.g., show an error message
        print('Login failed: $e');
        Get.snackbar('Login Error', 'Failed to log in: $e', backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }
}
