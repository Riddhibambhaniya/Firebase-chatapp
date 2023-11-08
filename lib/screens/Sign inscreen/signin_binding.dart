import 'package:get/get.dart';

import 'signin_controller.dart'; // Import the controller

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }
}
