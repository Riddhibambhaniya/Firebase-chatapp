import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../OTP screen/otpscreen_view.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> resetPassword(String email) async {
    try {
      isLoading(true);

      if (GetUtils.isEmail(email)) {
        // Use Firebase Authentication to send a password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        // Navigate to the OTP screen
        Get.off(() => OtpScreenView());

        Get.snackbar(
          'Success',
          'Password reset email sent successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Invalid email format',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send password reset email: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
