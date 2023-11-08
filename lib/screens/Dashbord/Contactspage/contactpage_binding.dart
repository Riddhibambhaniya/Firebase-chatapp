import 'package:get/get.dart';

import 'contactpage_controller.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ContactController());
  }
}