import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
class ChatPageController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString selectedUserId = ''.obs;
  RxString chatRoomId = ''.obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;
  late User currentUser;
  late TextEditingController messageController;
  StreamSubscription<QuerySnapshot>? messagesSubscription;

  @override
  void onInit() {
    super.onInit();
    currentUser = _auth.currentUser!;
    selectedUserId = ''.obs;
    messageController = TextEditingController();
    // Make sure selectedUserId is set before calling loadMessages
    chatRoomId.value = _chatRoomId();
    loadMessages();
    loadRecentChatMessages();
  }

  @override
  void onClose() {
    // Cancel the stream subscription to avoid memory leaks
    messagesSubscription?.cancel();
    super.onClose();
  }

  void loadMessages() {
    if (chatRoomId.isNotEmpty) {
      chatRoomId.refresh(); // Update chatRoomId before accessing its value
      messagesSubscription = firestore
          .collection('messages')
          .doc(chatRoomId.value)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((QuerySnapshot messagesSnapshot) {
        List<MessageModel> loadedMessages = messagesSnapshot.docs
            .map((messageDoc) => MessageModel.fromDocument(messageDoc))
            .toList();

        messages.assignAll(loadedMessages);

        // Print messages for debugging
        for (var message in messages) {
          print('Message: ${message.text}, Sender: ${message.senderId}');
        }
      });
    }
  }

  void loadRecentChatMessages() {
    firestore
        .collection('messages')
        .where('chatRoomId', isEqualTo: _recentChatRoomId())
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((QuerySnapshot messagesSnapshot) {
      List<MessageModel> loadedMessages = messagesSnapshot.docs
          .map((messageDoc) => MessageModel.fromDocument(messageDoc))
          .toList();

      messages.assignAll(loadedMessages);
    });
  }

  String _chatRoomId() {
    List<String> userIds = [currentUser.uid, selectedUserId.value];
    userIds.sort();
    return userIds.join('_');
  }

  String _recentChatRoomId() {
    List<String> userIds = [currentUser.uid, selectedUserId.value];
    userIds.sort();
    return userIds.join('_');
  }

  Future<void> sendMessage(String text) async {
    try {
      String chatRoomId = _chatRoomId();

      await firestore
          .collection('messages')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': currentUser.uid,
        'senderName': currentUser.displayName ?? '',
        'recipientId': selectedUserId.value,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}

class MessageModel {
  final String text;
  final String senderId;
  final Timestamp timestamp;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.timestamp,
  });

  factory MessageModel.fromDocument(QueryDocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null) {
      String text = data['text'] ?? '';
      String senderId = data['senderId'] ?? '';
      Timestamp timestamp = data['timestamp'] as Timestamp? ?? Timestamp.now();

      return MessageModel(
        text: text,
        senderId: senderId,
        timestamp: timestamp,
      );
    } else {
      return MessageModel(
        text: 'Error: Message data is null',
        senderId: '',
        timestamp: Timestamp.now(),
      );
    }
  }
}