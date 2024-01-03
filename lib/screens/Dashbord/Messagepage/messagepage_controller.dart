import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../../models/contectpagemodel.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;
  final RxList<UserDataWithLatestMessage> userData = <UserDataWithLatestMessage>[].obs;
  final RxList<UserData1> userList = <UserData1>[].obs;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    fetchUserList();
    initializeNotifications();
    fetchCurrentUserRecentChats();
  }

  // Initialize local notifications
  void initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show a notification
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> startChat(UserData1 otherUser) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Create a new chat session or get an existing one
        final chatId = await _getOrCreateChat(currentUser.uid, otherUser.uuid);

        print("chatId $chatId");
        // Navigate to the chat page with the chat ID
        Get.toNamed('/chat', arguments: {
          'chatId': chatId,
          'name': otherUser.name,
          'uuid': otherUser.uuid
        });
      }
    } catch (e) {
      print('Failed to start chat: $e');
    }
  }

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? '${userID}_$peerID'
        : '${peerID}_$userID';
  }

  Future<String> _getOrCreateChat(String userId, String otherUserId) async {
    final chatId = getConversationID(userId, otherUserId);

    return chatId;
  }

  Future<void> fetchUserList() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final users = await FirebaseFirestore.instance.collection('users').get();

        userList.assignAll(users.docs.map<UserData1>((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return UserData1(
            name: data['name'] ?? 'Default Name',
            uuid: data['uuid'] ?? '',
            email: data['email'] ?? '',
          );
        }));

        update();
      }
    } catch (e) {
      print('Failed to fetch user list: $e');
    }
  }

  Future<void> fetchCurrentUserRecentChats() async {
    try {
      final currentUser = _auth.currentUser;
      final senderId = currentUser?.uid;

      if (senderId != null) {
        userData.clear();

        final recentMessages = await _firestore
            .collection('chats')
            .where('members', arrayContains: senderId)
            .get();

        for (final doc in recentMessages.docs) {
          final members = doc['members'] as List<dynamic>;

          if (members.isNotEmpty) {
            final otherUserId = members.firstWhere(
                  (member) => member != senderId,
              orElse: () => null,
            ) as String?;

            if (otherUserId != null) {
              final lastMessageSnapshot = await _firestore
                  .collection('chats/${doc.id}/messages')
                  .orderBy('timestamp', descending: true)
                  .limit(1)
                  .get();

              if (lastMessageSnapshot.docs.isNotEmpty) {
                final lastMessageData =
                lastMessageSnapshot.docs.first.data() as Map<String, dynamic>;
                final timestamp = lastMessageData['timestamp']?.toDate();
                final lastMessageContent = lastMessageData['messageContent'] ?? '';

                userData.add(UserDataWithLatestMessage(
                  userData: UserData1(
                    uuid: otherUserId,
                    name: lastMessageData['senderName'],
                    email: lastMessageData['senderEmail'],
                  ),
                  lastMessageContent: lastMessageContent,
                  lastMessageTimestamp: timestamp,
                  messageCount: lastMessageSnapshot.size,
                ));
              }
            }
          }
        }

        userData.sort((a, b) =>
            (b.lastMessageTimestamp ?? DateTime(0))
                .compareTo(a.lastMessageTimestamp ?? DateTime(0)));
      }
    } catch (e) {
      print('Failed to fetch recent chats: $e');
    }
  }
}

class UserDataWithLatestMessage {
  final UserData1 userData;
  final String lastMessageContent;
  final DateTime? lastMessageTimestamp;
  final int messageCount;

  UserDataWithLatestMessage({
    required this.userData,
    required this.lastMessageContent,
    required this.lastMessageTimestamp,
    required this.messageCount,
  });
}
