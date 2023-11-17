import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/chatmessage.dart';

class ChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  var isTextInputOpen = false.obs;
  final messageEditingController = TextEditingController();

  final CollectionReference messagesCollection =
  FirebaseFirestore.instance.collection('messages');

  Future<void> sendMessage(String message, String recipientName) async {
    await messagesCollection.add({
      'senderName': 'You',
      'messageContent': message,
      'recipientName': recipientName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    final newMessage = ChatMessage('You', message);
    messages.add(newMessage);
  }

  void listenForMessages(String recipientName) {
    messagesCollection
        .where('recipientName', isEqualTo: recipientName)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final messageData = change.doc.data();
          if (messageData != null) {
            final senderName = messageData['senderName'];
            final messageContent = messageData['messageContent'];

            final newMessage = ChatMessage(senderName, messageContent);
            messages.add(newMessage);
          }
        }
      }
    } as void Function(QuerySnapshot<Object?> event)?);
  }

  @override
  void onClose() {
    super.onClose();
    messageEditingController.dispose();
  }
}
