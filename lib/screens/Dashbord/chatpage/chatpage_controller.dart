import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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

  // Define onNewMessage callback property
  void Function()? onNewMessage;

  @override
  void onInit() {
    super.onInit();

    final String? recipientId = Get.arguments['uuid']; // Use the recipient ID from the route arguments
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
  }

  Future<void> onSelectNotification(String? payload) async {
    print('Notification tapped with payload: $payload');
  }

  void showNotification(String title, String lastMessageContent) async {
    final user = _auth.currentUser;
    final senderName = user?.displayName ?? 'You';

    String notificationBody = 'New Message from $senderName: $lastMessageContent';

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // Change this to your channel ID
      'Your Channel Name', // Change this to your channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      notificationBody,
      platformChannelSpecifics,
      payload: 'New Message', // You can add additional data to handle tap
    );
  }


  Future<void> pickImage(String recipientId) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String? imageUrl = await uploadImage(File(image.path) as String);
      sendMessage(recipientId, 'Image', imageUrl);
    }
  }
  Future<String?> uploadImage(String filePath) async {
    try {
      final user = _auth.currentUser;
      final senderId = user?.uid;

      if (senderId != null) {
        final storageReference = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('chat_images')
            .child('$senderId-${DateTime.now().millisecondsSinceEpoch}.jpg');

        final storageUploadTask = storageReference.putFile(File(filePath));
        final storageTaskSnapshot = await storageUploadTask;

        final imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
        return imageUrl;
      }
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  void listenForMessages(String recipientId) {
    final user = _auth.currentUser;
    final senderId = user?.uid;

    if (senderId != null) {
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
          newMessages.isNotEmpty ? newMessages.first.messageContent : null;
          lastReceivedMessage.value = lastMessage ?? '';

          if (newMessages.isNotEmpty) {
            showNotification(
              'New Message from ${user?.displayName ?? ''}',
              newMessages.first.messageContent,
            );
          }

          // Notify about new messages
          if (onNewMessage != null) {
            onNewMessage!();
          }

          // Update the UI of the current chat page
          update();
        } catch (e) {
          print('Error listening for messages: $e');
        }
      });
    }
  }

  Future<String?> sendMessage(String recipientId, String messageContent, String? imageUrl) async {
    try {
      final user = _auth.currentUser;
      final senderId = user?.uid;
      final senderName = user?.displayName ?? 'You';

      if (senderId != null) {
        String chatId = getChatId(senderId, recipientId);
        String chatCollectionPath = 'chats/$chatId/messages';

        DocumentReference documentReference = await _firestore.collection(chatCollectionPath).add({
          'senderId': senderId,
          'recipientId': recipientId,
          'messageContent': messageContent,
          'timestamp': FieldValue.serverTimestamp(),
          'senderName': senderName,
          'last-message': imageUrl != null ? 'Image' : messageContent,
          'imageUrl': imageUrl, // Add imageUrl to the document if it's an image message
        });

        String documentId = documentReference.id;

        lastSentMessage.value = messageContent;
        messageEditingController.clear();

        listenForMessages(recipientId, /* provide user data here if needed */);
        updateMessagePage();

        return documentId;
      }
    } catch (e) {
      print('Failed to send message: $e');
      return null;
    }
  }

  String getChatId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }

  void updateMessagePage() {
    Get.find<MessageController>().fetchCurrentUserLastMessages();
  }

  @override
  void onClose() {
    super.onClose();
    messageEditingController.dispose();
  }
}
