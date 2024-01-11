import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GroupChatController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late User currentUser;
  late String groupId; // Group identifier

  RxList<MessageModel> messages = <MessageModel>[].obs;

  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    currentUser = _auth.currentUser!;
    // Load group messages when the page is initialized
    loadGroupMessages();
  }


  // Add a method to filter messages based on the selected group
  void filterMessages(String groupId) {
    messages.refresh(); // Clear existing messages
    messages.addAll(messages.where((message) => message.groupId == groupId));
  }
  void loadGroupMessages() async {
    try {
      QuerySnapshot messagesSnapshot = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      List<MessageModel> loadedMessages = messagesSnapshot.docs
          .map((messageDoc) => MessageModel.fromDocument(messageDoc))
          .toList();

      messages.assignAll(loadedMessages);
    } catch (e) {
      print('Error loading group messages: $e');
      Get.snackbar('Error', 'Failed to load group messages. Please try again.');
    }
  }

  void sendMessage() async {
    try {
      String text = messageController.text.trim();
      if (text.isNotEmpty) {
        await firestore
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .add({
          'text': text,
          'senderId': currentUser.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear the message input field after sending the message
        messageController.clear();
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}

class MessageModel {
  final String text;
  final String senderId;
  final String groupId; // Add this property
  final DateTime timestamp;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.groupId,
    required this.timestamp,
  });

  factory MessageModel.fromDocument(QueryDocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    String text = data['text'] ?? '';
    String senderId = data['senderId'] ?? '';
    String groupId = data['groupId'] ??
        ''; // Replace 'groupId' with the actual field name in your Firestore document
    DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

    return MessageModel(
      text: text,
      senderId: senderId,
      groupId: groupId,
      timestamp: timestamp,
    );
  }
}