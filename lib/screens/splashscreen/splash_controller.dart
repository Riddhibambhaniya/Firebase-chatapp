// import 'dart:async';
//
// import 'package:get/get.dart';
//
// import '../../routes/app_routes.dart';
//
//
// class SplashController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     Future.delayed(const Duration(seconds: 3), () {
//       Get.toNamed(Routes.onboarding);
//     });
//   }
// }


import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../routes/app_routes.dart';

class SplashController extends GetMaterialController  {
  @override
  void onInit() {
    super.onInit();
    checkUserLoginStatus();
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
