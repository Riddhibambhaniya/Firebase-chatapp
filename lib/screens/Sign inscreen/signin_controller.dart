import 'package:cloud_firestore/cloud_firestore.dart';
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

  //



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
            // Retrieve the user's data from Firebase Firestore
            final userDoc = await FirebaseFirestore.instance.collection('users').doc(userUid).get();
            final userUuid = userDoc.data()?['uuid'];
            final userName = userDoc.data()?['name'];
            final userEmail = userDoc.data()?['email'];

            // Pass the user's data to the contact list and chat page
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
        Get.snackbar('Login Error', 'Failed to log in: $e', backgroundColor: Colors.red, colorText: Colors .white);
      }
    }
  }

}
