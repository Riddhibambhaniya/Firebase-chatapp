import 'package:get/get.dart';

import 'messagepage_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MessageController()); // Register MessageController
  }
}