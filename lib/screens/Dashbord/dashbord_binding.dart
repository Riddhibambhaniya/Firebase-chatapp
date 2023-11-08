import 'package:get/get.dart';

import 'dashbord_controller.dart';
 // Import the controller

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>DashboardController());
  }
}
