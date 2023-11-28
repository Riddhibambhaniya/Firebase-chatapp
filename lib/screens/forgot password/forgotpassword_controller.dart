import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  void resetPassword(String email) async {
    try {
      isLoading(true);

      // Simulate password reset logic
      // Replace this with your actual password reset logic
      await Future.delayed(Duration(seconds: 2));

      // Display success message
      Get.snackbar('Success', 'Password reset email sent successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Display error message
      Get.snackbar('Error', 'Failed to send password reset email',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
