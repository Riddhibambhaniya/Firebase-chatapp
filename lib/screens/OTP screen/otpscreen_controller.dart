import 'package:get/get.dart';
import '../ResetPasswordScreen/resetPasswordScreen_view.dart';

class OtpScreenController extends GetxController {
  static OtpScreenController get to => Get.find();

  final RxString otp = ''.obs;

  void onOtpChanged(String value) {
    otp.value = value;
  }

  Future<void> verifyOtp() async {
    try {
      // Verify the OTP (add your own verification logic)
      // If OTP is verified, navigate to the next screen (e.g., PasswordResetScreen)
      Get.off(ResetPasswordScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify OTP: $e');
    }
  }
}
