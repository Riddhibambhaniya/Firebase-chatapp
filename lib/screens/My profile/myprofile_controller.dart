import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Firebase/auth_controller.dart';

class MyProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  // Method to log out the user and clear user data

  void logOut() {

    authController.signOutAndNavigateToOnboarding(); // Call the new method
  }
  // Method to clear user data
  void clearUserData() {
    // Implement clearing user data here
    // You can add your code to clear user-specific data from SharedPreferences, etc.
  }
}
