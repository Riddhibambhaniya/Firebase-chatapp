import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';
import '../My profile/myprofile_controller.dart';

class SignInController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isFormValid = false.obs;
  String? userUuid;
  String? userName;
  String? userEmail;

  String? validateEmail(String? value) {}

  String? validatePassword(String? value) {}
  MyProfileController myProfileController = Get.put(MyProfileController());
  @override
  void onInit() {
    super.onInit();
    ever(myProfileController.userEmail, (_) {
      // This will be triggered whenever userEmail in MyProfileController changes
      if (email.value != myProfileController.userEmail.value) {
        email.value = myProfileController.userEmail.value;
        emailController.text = myProfileController.userEmail.value;
      }
    });
  }
  Future<void> signIn() async {
    if (validateEmail(email.value) == null &&
        validatePassword(password.value) == null) {
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email.value,
          password: password.value,
        );

        if (userCredential.user != null) {
          final userUid = userCredential.user?.uid;

          if (userUid != null) {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .get();

            final userUuid = userDoc.data()?['uuid'];
            final userName = userDoc.data()?['name'];
            final userEmail = userDoc.data()?['email'];

            // Save user data to SharedPreferences
            saveUserDataToSharedPreferences(userUuid, userName, userEmail);

            // Update MyProfileController
            Get.find<MyProfileController>().updateProfileDetails(
              userUuid: userUuid,
              userName: userName,
              userEmail: userEmail,
            );

            Get.toNamed(
              Routes.home,
              arguments: {
                'uuid': userUuid,
                'name': userName,
                'email': userEmail,
              },
            );
          } else {
            print('Login failed: User not found');
            Get.snackbar('Login Error', 'Failed to log in: User not found',
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        }
      } catch (e) {
        print('Login failed: $e');
        Get.snackbar('Login Error', 'Failed to log in: $e',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  void updateButtonColor() {
    isFormValid.value = validateEmail(email.value) == null &&
        validatePassword(password.value) == null;
  }

  Future<void> saveUserDataToSharedPreferences(
      String? uuid, String? name, String? email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_uuid', uuid ?? '');
    prefs.setString('user_name', name ?? '');
    prefs.setString('user_email', email ?? '');
  }
}
