import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

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

  bool get isValidForm {
    return nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  Future<void> createAccount() async {
    final nameValidation = validateName(name.value);
    final emailValidation = validateEmail(email.value);
    final passwordValidation = validatePassword(password.value);
    final confirmPasswordValidation = validateConfirmPassword(confirmPassword.value);

    if (nameValidation == null &&
        emailValidation == null &&
        passwordValidation == null &&
        confirmPasswordValidation == null) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email.value,
          password: password.value,
        );

        final user = _auth.currentUser;
        final userUID = user?.uid;

        // Store data in Firestore using userUID as a reference.

        Get.toNamed('/home');
      } catch (e) {
        print('Registration failed: $e');
      }
    } else {
      print('Form validation failed.');
    }
  }
}
