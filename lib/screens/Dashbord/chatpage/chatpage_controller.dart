import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/foundation.dart' as foundation;
import '../../../models/chatmessage.dart';
import '../Messagepage/messagepage_controller.dart';

class ChatController extends GetxController {
  RxString lastReceivedMessage = ''.obs;
  RxString lastSentMessage = ''.obs;

  final messages = <ChatMessage>[].obs;
  var isTextInputOpen = false.obs;
  final messageEditingController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();

    final String? recipientId = 'someRecipientId';
    listenForMessages(recipientId ?? '');

    initializeLocalNotifications();
  }

  void initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Set up the notification tap handling
    // flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   onSelectNotification: (String? payload) async {
    //     // Handle notification tap
    //     print('Notification tapped with payload: $payload');
    //   },
    // );
  }



  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap
    print('Notification tapped with payload: $payload');
  }

  void showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // Change this to your channel ID
      'Your Channel Name', // Change this to your channel name
     // 'Your Channel Description', // Change this to your channel description
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'New Message', // You can add additional data to handle tap
    );
  }

  void listenForMessages(String recipientId) {
    final user = _auth.currentUser;
    final senderId = user?.uid;

    if (senderId != null) {
      // Create a unique chat ID based on user IDs
      String chatId = getChatId(senderId, recipientId);

      String chatCollectionPath = 'chats/$chatId/messages';

      _firestore
          .collection(chatCollectionPath)
          .orderBy('timestamp', descending: true)
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

          // Show notification when a new message is received
          if (newMessages.isNotEmpty) {
            showNotification(
              'New Message from ${user?.displayName ?? ''}',
              newMessages.last.messageContent,
            );
          }

          updateMessagePage();
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
        // Create a unique chat ID based on user IDs
        String chatId = getChatId(senderId, recipientId);

        String chatCollectionPath = 'chats/$chatId/messages';

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

        lastSentMessage.value = messageContent;
        messageEditingController.clear();

        // Fetch updated messages and trigger MessagePage update
        listenForMessages(recipientId);
        updateMessagePage();

        return documentId;
      }
    } catch (e) {
      print('Failed to send message: $e');
      return null;
    }
  }

// Helper function to get a unique chat ID based on user IDs
  String getChatId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }

  // Helper function to trigger MessagePage update
  void updateMessagePage() {
    Get.find<MessageController>().update();
  }

  @override
  void onClose() {
    super.onClose();
    messageEditingController.dispose();
  }
}
