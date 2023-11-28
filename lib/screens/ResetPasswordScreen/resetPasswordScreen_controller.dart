// reset_password_controller.dart
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final RxString oldPassword = ''.obs;
  final RxString newPassword = ''.obs;

  void onOldPasswordChanged(String value) {
    oldPassword.value = value;
  }

  void onNewPasswordChanged(String value) {
    newPassword.value = value;
  }

  Future<void> resetPassword() async {
    try {
      // Implement your password reset logic here
      Get.snackbar('Success', 'Password reset successful');
    } catch (e) {
      Get.snackbar('Error', 'Failed to reset password: $e');
    }
  }
}
