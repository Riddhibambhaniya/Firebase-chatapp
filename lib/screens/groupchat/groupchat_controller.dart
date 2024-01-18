import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatController extends GetxController {
  late String groupId;
  late RxList<String> messages;
  late TextEditingController textEditingController;

  @override
  void onInit() {
    super.onInit();
    messages = <String>[].obs;
    textEditingController = TextEditingController();
  }

  void loadMessages() {
    // Logic to load group messages from Firestore
    // You can use the groupId to fetch messages for this group
    // Update the 'messages' list with the loaded messages
  }

  void sendMessage(String message) async {
    // Logic to send a message to the group
    // Update the Firestore collection for this group with the new message
    await FirebaseFirestore.instance.collection('groups').doc(groupId).collection('messages').add({
      'senderId': 'currentUserId', // Replace with the actual sender's ID
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Clear the text field after sending the message
    textEditingController.clear();
  }
}
