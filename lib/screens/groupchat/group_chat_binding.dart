import 'package:get/get.dart';

import 'groupchat_controller.dart';



class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GroupChatController());
  }
}
