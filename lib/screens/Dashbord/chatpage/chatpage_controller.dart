
import 'package:get/get.dart';

import '../../../models/chatmessage.dart';
import 'chatpage_view.dart';

class ChatController extends GetxController {
  //var messages = <String>[].obs; // Example list of messages
  final messages = <ChatMessage>[].obs;
  var isTextInputOpen = false.obs; // Define isTextInputOpen as an RxBool

  void sendMessage(String message) {
    final newMessage = ChatMessage("You", message);
    messages.add(newMessage);
    // You can also add code to handle receiving messages from others here.
  }
}

