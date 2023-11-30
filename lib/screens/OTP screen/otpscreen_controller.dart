import 'package:get/get.dart';
import '../ResetPasswordScreen/resetPasswordScreen_view.dart';

class OtpScreenController extends GetxController {
  static OtpScreenController get to => Get.find();

  final RxString otp = ''.obs;
  final RxString email = ''.obs;

  void onOtpChanged(String value) {
    otp.value = value;
  }

  Future<void> verifyOtp() async {
    try {
      // Implement your OTP verification logic here
      // If OTP is verified, navigate to the next screen (e.g., ResetPasswordScreen)
      Get.off(() => ResetPasswordScreen(email: email.value));
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify OTP: $e');
    }
  }
}
