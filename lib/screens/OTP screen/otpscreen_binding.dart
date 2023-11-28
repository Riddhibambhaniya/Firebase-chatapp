// otp_screen_binding.dart

import 'package:get/get.dart';

import 'otpscreen_controller.dart';


class OtpScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpScreenController>(() => OtpScreenController());
  }
}
