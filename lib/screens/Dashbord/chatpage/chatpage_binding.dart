
import 'package:get/get.dart';

import 'chatpage_controller.dart';


class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatPageController>(() => ChatPageController());
  }
}
