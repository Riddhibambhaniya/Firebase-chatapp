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
    fetchCurrentUserRecentChats();
  }

  Future<void> fetchCurrentUserRecentChats() async {
    try {
      print('Fetching recent chats...');
      final user = _auth.currentUser;
      final senderId = user?.uid;

      if (senderId != null) {
        userData.clear(); // Clear existing data

        final recentChats = await _firestore
            .collection('users/$senderId/chatwith')
            .orderBy('timestamp', descending: true)
            .get();

        for (final doc in recentChats.docs) {
          final recipientId = doc.id;
          final lastMessageData =
          await fetchLastMessageData(senderId, recipientId);

          if (lastMessageData != null) {
            userData.add(UserData1(
              uuid: recipientId,
              name: lastMessageData['senderName'],
              email: "",
              lastMessageContent: lastMessageData['messageContent'],
              lastMessageTimestamp: lastMessageData['timestamp'],


                // 'senderId': userId,
                // 'recipientId': otherUserId,
                // 'senderName': userName,
                // 'messageContent': messageContent,
                // 'timestamp': FieldValue.serverTimestamp(),

            ));
          }
        }

        update(); // Trigger UI update
      }
    } catch (e) {
      print('Failed to fetch recent chats: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchLastMessageData(
      String senderId, String recipientId) async {
    try {
      final chatId = getConversationID(senderId, recipientId);
      final chatCollectionPath = 'chats/$chatId/messages';

      final lastMessageSnapshot = await _firestore
          .collection(chatCollectionPath)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (lastMessageSnapshot.docs.isNotEmpty) {
        final lastMessageData =
        lastMessageSnapshot.docs.first.data() as Map<String, dynamic>;
        final timestamp = lastMessageData['timestamp']?.toDate();
        final lastMessageContent = lastMessageData['messageContent'] ?? '';

        return {
          'senderName': lastMessageData['senderName'],
          'senderEmail': lastMessageData['senderEmail'],
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


  String getConversationID(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }
}
