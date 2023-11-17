import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../My profile/myprofile_controller.dart';

class SignInController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userUuid;
  String? userName;
  String? userEmail;

  // String _userUuidKey = 'user_uuid';
  // String _userNameKey = 'user_name';
  // String _userEmailKey = 'user_email';
   // Add user UUID key

  String? validateEmail(String? value) {
    // Your email validation logic
  }

  String? validatePassword(String? value) {
    // Your password validation logic
  }

  Future<void> signIn() async {
    if (validateEmail(email.value) == null && validatePassword(password.value) == null) {
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email.value,
          password: password.value,
        );

        if (userCredential.user != null) {
          final userUid = userCredential.user?.uid;

          if (userUid != null) {
            final userDoc = await FirebaseFirestore.instance.collection('users').doc(userUid).get();
            final userUuid = userDoc.data()?['uuid'];
            final userName = userDoc.data()?['name'];
            final userEmail = userDoc.data()?['email'];

            // Save user data to shared preferences
            saveUserDataToSharedPreferences(userUuid, userName, userEmail);

            // Pass the user's data to the home page
            Get.toNamed(
              '/home',
              arguments: {
                'uuid': userUuid,
                'name': userName,
                'email': userEmail,
              },
            );
          } else {
            // Handle authentication errors, e.g., show an error message
            print('Login failed: User not found');
            Get.snackbar('Login Error', 'Failed to log in: User not found', backgroundColor: Colors.red, colorText: Colors.white);
          }
        }
      } catch (e) {
        // Handle authentication errors, e.g., show an error message
        print('Login failed: $e');
        Get.snackbar('Login Error', 'Failed to log in: $e', backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<void> saveUserDataToSharedPreferences(String? uuid, String? name, String? email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_uuid', uuid ?? '');
    prefs.setString('user_name', name ?? '');
    prefs.setString('user_email', email ?? '');
  }
}
