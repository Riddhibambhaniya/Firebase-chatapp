
import 'package:get/get.dart';

import '../../../models/chatmessage.dart';


class ChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  var isTextInputOpen = false.obs; // Define isTextInputOpen as an RxBool

  void sendMessage(String message, recipientName) {
    final newMessage = ChatMessage("You", message);
    messages.add(newMessage);
  }
}

