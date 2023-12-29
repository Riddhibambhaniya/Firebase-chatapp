// MessageController.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../models/contectpagemodel.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<UserData1> userData = <UserData1>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUserLastMessages();
  }

  Future<void> fetchCurrentUserLastMessages() async {
    try {
      final user = _auth.currentUser;
      final senderId = user?.uid;

      if (senderId != null) {
        userData.clear();

        final lastMessages = await _firestore.collection('users/$senderId/chatwith').get();

        for (final doc in lastMessages.docs) {
          final recipientId = doc.id;

          // Fetch the last message and its timestamp
          final lastMessageData = await fetchLastMessageData(senderId, recipientId);

          if (lastMessageData != null) {
            userData.add(UserData1(
              uuid: recipientId,
              name: lastMessageData['username'],
              // profilepicture: lastMessageData['profilepicture'],
              email: lastMessageData['email'],
              // phoneNumber: lastMessageData['phonenumber'],
              lastMessageContent: lastMessageData['lastMessageContent'],
              lastMessageTimestamp: lastMessageData['lastMessageTimestamp'],
            ));
          }
        }

        update(); // Trigger UI update
      }
    } catch (e) {
      print('Failed to fetch last messages: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchLastMessageData(String senderId, String recipientId) async {
    try {
      final chatId = getChatId(senderId, recipientId);
      final chatCollectionPath = 'chats/$chatId/messages';

      final lastMessageSnapshot = await _firestore
          .collection(chatCollectionPath)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (lastMessageSnapshot.docs.isNotEmpty) {
        final lastMessageData = lastMessageSnapshot.docs.first.data() as Map<String, dynamic>;
        final timestamp = lastMessageData['timestamp']?.toDate();
        final lastMessageContent = lastMessageData['messageContent'] ?? '';

        return {
          'username': lastMessageData['senderName'],
          'profilepicture': '',  // Replace with your logic to get the profile picture
          'email': '',  // Replace with your logic to get the email
          'phonenumber': '',  // Replace with your logic to get the phone number
          'lastMessageContent': lastMessageContent,
          'lastMessageTimestamp': timestamp,
        };
      }

      return null;
    } catch (e) {
      print('Failed to fetch last message data: $e');
      return null;
    }
  }

  String getChatId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }
}
