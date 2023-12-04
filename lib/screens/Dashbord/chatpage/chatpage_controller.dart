import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  RxBool noChatHistory = false.obs; // Flag to track chat history

  @override
  void onInit() async {
    super.onInit();
    final String? recipientId = 'someRecipientId';
    await initializeChatHistoryFlag(); // Initialize chat history flag
    listenForMessages(recipientId ?? '');

    initializeLocalNotifications();
  }

  Future<void> initializeChatHistoryFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasChatHistory = prefs.getBool('hasChatHistory') ?? false;

    // If the user has no chat history, set the flag to true
    if (!hasChatHistory) {
      noChatHistory.value = true;
      prefs.setBool('hasChatHistory', true);
    }
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
  }

  Future<void> onSelectNotification(String? payload) async {
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
      payload: 'New Message',
    );
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

          if (messages.isEmpty) {
            noChatHistory.value = true;
          } else {
            noChatHistory.value = false;
          }

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

  Future<String?> sendMessage(
      String recipientId, String messageContent) async {
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

        Get.find<MessageController>().fetchLastMessages();
        updateMessagePage();

        return documentId;
      }
    } catch (e) {
      print('Failed to send message: $e');
      return null;
    }
  }

  void updateMessagePage() {
    Get.find<MessageController>().update();
  }

  @override
  void onClose() {
    super.onClose();
    messageEditingController.dispose();
  }
}
