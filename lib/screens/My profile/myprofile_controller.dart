import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Firebase/auth_controller.dart';

class MyProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();


  var userName = ''.obs;
  var userEmail = ''.obs;



  @override
  Future<void> onInit() async {
    super.onInit();
    // Retrieve user data from shared preferences
    await  getUserDataFromSharedPreferences();
  }

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? '';
    userEmail.value = prefs.getString('user_email') ?? '';
  }
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
