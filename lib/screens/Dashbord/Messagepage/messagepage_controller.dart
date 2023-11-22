import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../models/chatmessage.dart';
import '../../../models/messageusermodel.dart';
import 'mesagepage_view.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<UserData> userData = <UserData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLastMessages();
  }

  Future<void> fetchLastMessages() async {
    try {
      final user = _auth.currentUser;
      final senderId = user?.uid;

      if (senderId != null) {
        // Fetch the last messages for each user
        final QuerySnapshot<Map<String, dynamic>> lastMessages =
        await _firestore.collection('users/$senderId/chatwith').get();

        // Use a Map to store the last message for each user
        final Map<String, ChatMessage> lastMessagesMap = {};

        for (final doc in lastMessages.docs) {
          final data = doc.data();
          final lastMessage = ChatMessage.fromMap(data!);

          final recipientId = lastMessage.recipientId;

          // Check if there is a stored last message for this user
          if (!lastMessagesMap.containsKey(recipientId) ||
              lastMessage.timestamp!.toDate().isAfter(
                lastMessagesMap[recipientId]?.timestamp?.toDate() ?? DateTime(0),
              )) {
            lastMessagesMap[recipientId] = lastMessage;
          }
        }

        // Fetch user data and create UserData instances
        for (final entry in lastMessagesMap.entries) {
          final recipientId = entry.key;
          final lastMessage = entry.value;

          final recipientData =
          await _firestore.collection('users').doc(recipientId).get();

          if (recipientData.exists) {
            final timestamp = lastMessage.timestamp;

            if (timestamp != null) {
              userData.add(UserData(
                userUuid: recipientId,
                username: recipientData.get("name"),
                details: lastMessage.messageContent,
                avatar: recipientData.get("profilepicture"),
                lastMessageTimestamp: timestamp
                    .toDate(),
              ));
            }
          }
        }
      }
    } catch (e) {
      print('Failed to fetch last messages: $e');
    }
  }
}
