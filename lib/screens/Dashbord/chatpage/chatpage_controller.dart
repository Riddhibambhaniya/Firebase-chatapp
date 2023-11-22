import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/chatmessage.dart';

class ChatController extends GetxController {
  RxString lastReceivedMessage = ''.obs;
  RxString lastSentMessage = ''.obs;

  final messages = <ChatMessage>[].obs;
  var isTextInputOpen = false.obs;
  final messageEditingController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onInit() {
    super.onInit();
    final String? recipientId = 'someRecipientId'; // Replace with your logic
    listenForMessages(recipientId ?? '');
  }

  void listenForMessages(String recipientId) {
    final user = _auth.currentUser;
    final senderId = user?.uid;

    if (senderId != null) {
      String chatCollectionPath = 'users/$recipientId/chatwith';

      _firestore
          .collection(chatCollectionPath)
          .orderBy('timestamp', descending: false)
          .snapshots()
          .listen((querySnapshot) {
        try {
          final List<ChatMessage> newMessages = [];

          for (final doc in querySnapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final message = ChatMessage.fromMap(data);
            newMessages.add(message);
          }

          messages.value = newMessages;

          String? lastMessage =
          newMessages.isNotEmpty ? newMessages.last.messageContent : null;
          lastReceivedMessage.value = lastMessage ?? '';
          update();
        } catch (e) {
          print('Error listening for messages: $e');
        }
      });
    }
  }

  Future<String?> sendMessage(String recipientId, String messageContent) async {
    try {
      final user = _auth.currentUser;
      final senderId = user?.uid;
      final senderName = user?.displayName ?? 'You';

      if (senderId != null) {
        String chatCollectionPath = 'users/$recipientId/chatwith';

        DocumentReference documentReference =
        await _firestore.collection(chatCollectionPath).add({
          'senderId': senderId,
          'recipientId': recipientId,
          'messageContent': messageContent,
          'timestamp': FieldValue.serverTimestamp(),
          'senderName': senderName,
          'last-message': messageContent,
        });

        String documentId = documentReference.id;

        String senderChatCollectionPath = 'users/$senderId/chatwith';
        await _firestore.collection(senderChatCollectionPath).add({
          'senderId': senderId,
          'recipientId': recipientId,
          'messageContent': messageContent,
          'timestamp': FieldValue.serverTimestamp(),
          'senderName': senderName,
          'last-message': messageContent,
        });

        lastSentMessage.value = messageContent;
        messageEditingController.clear();

        return documentId;
      }
    } catch (e) {
      print('Failed to send message: $e');
      return null;
    }
  }

  @override
  void onClose() {
    super.onClose();
    messageEditingController.dispose();
  }
}
