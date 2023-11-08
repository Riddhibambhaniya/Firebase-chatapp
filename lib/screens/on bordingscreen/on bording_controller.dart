import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> register() async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //       email: '', // Replace with user input
  //       password: '',       // Replace with user input
  //     );
  //     Get.toNamed('/home'); // Navigate to the home screen upon successful registration
  //   } catch (e) {
  //     Get.snackbar(
  //       'Registration Error',
  //       e.toString(),
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
  //
  // Future<void> login() async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(
  //       email: '', // Replace with user input
  //       password: '',       // Replace with user input
  //     );
  //     Get.toNamed('/home'); // Navigate to the home screen upon successful login
  //   } catch (e) {
  //     Get.snackbar(
  //       'Login Error',
  //       e.toString(),
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
}