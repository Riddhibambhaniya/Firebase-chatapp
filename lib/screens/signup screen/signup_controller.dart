import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../routes/app_routes.dart';

class SignUpController extends GetxController {
  final RegExp _phoneNumberRegExp = RegExp(r'^[0-9]{10}$');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final phoneNumber = ''.obs;
  RxBool isFormValid = false.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? phoneNumberError;


  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      nameError = "Name is required";
    } else {
      nameError = null;
    }
    return nameError;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      emailError = "Email is required";
    } else if (!GetUtils.isEmail(value)) {
      emailError = "Invalid email format";
    } else {
      emailError = null;
    }
    return emailError;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      passwordError = "Password is required";
    } else if (value.length < 6) {
      passwordError = "Password must be at least 6 characters";
    } else {
      passwordError = null;
    }
    return passwordError;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      confirmPasswordError = "Confirm Password is required";
    } else if (value != password.value) {
      confirmPasswordError = "Passwords do not match";
    } else {
      confirmPasswordError = null;
    }
    return confirmPasswordError;
  }

  String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Please enter a phone number';
    } else if (!_phoneNumberRegExp.hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  bool get isValidForm {
    return nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        phoneNumberError == null;
  }

  void updateButtonColor() {
    isFormValid.value = validateName(name.value) == null &&
        validateEmail(email.value) == null &&
        validatePassword(password.value) == null &&
        validateConfirmPassword(confirmPassword.value) == null &&
        validatePhoneNumber(phoneNumber.value) == null;

    print('Name: ${name.value}');
    print('Email: ${email.value}');
    print('Password: ${password.value}');
    print('Confirm Password: ${confirmPassword.value}');
    print('isFormValid: ${isFormValid.value}');
  }

  Future<void> createAccount() async {
    final nameValidation = validateName(name.value);
    final emailValidation = validateEmail(email.value);
    final passwordValidation = validatePassword(password.value);
    final confirmPasswordValidation =
    validateConfirmPassword(confirmPassword.value);
    final phoneNumberValidation = validatePhoneNumber(phoneNumber.value);

    if (nameValidation == null &&
        emailValidation == null &&
        passwordValidation == null &&
        confirmPasswordValidation == null &&
        phoneNumberValidation == null) {
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.value,
          password: password.value,
        );

        final user = userCredential.user;
        final userUID = user?.uid;

        // Generate a UUID for the user
        //  final userUUID = Uuid().v4();

        // Send email verification link
        await user?.sendEmailVerification();

        // Introduce a delay to allow Firestore document creation
        await Future.delayed(Duration(seconds: 2));

        // Store user data in Firestore with the UUID
        await FirebaseFirestore.instance.collection('users').doc(userUID).set({
          'name': name.value,
          'email': email.value,
          'phoneNumber': phoneNumber.value,
          'uuid': userUID,
        });

        // Now you have associated the UUID with the user in Firestore

        Get.toNamed(Routes.home);
      } catch (e) {
        print('Registration failed: $e');
        // Handle registration failure, e.g., show an error message
      }
    } else {
      print('Form validation failed.');
      // Handle form validation failure, e.g., show an error message
    }
  }
}
