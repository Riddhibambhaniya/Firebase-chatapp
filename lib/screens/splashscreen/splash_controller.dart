import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Delay the navigation to give time for the widget tree to settle
    Future.delayed(const Duration(seconds: 3), () {
      checkUserLoginStatus();
    });
  }

  Future<void> checkUserLoginStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // User is logged in, navigate to home/dashboard screen
      Get.offNamed(Routes.home);
    } else {
      // User is not logged in, navigate to onboarding screen
      Get.offNamed(Routes.onboarding);
    }
  }
}
