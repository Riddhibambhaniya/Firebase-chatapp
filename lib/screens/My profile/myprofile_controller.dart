import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Firebase/auth_controller.dart';

class MyProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  var userName = ''.obs;
  var userEmail = ''.obs;
  var userProfilePic = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await getUserDataFromSharedPreferences();
  }

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? '';
    userEmail.value = prefs.getString('user_email') ?? '';
    userProfilePic.value = prefs.getString('user_profile_pic') ?? '';
  }

  void logOut() {
    authController.signOutAndNavigateToOnboarding();
  }

  void clearUserData() {}
}
