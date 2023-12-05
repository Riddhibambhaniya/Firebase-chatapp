// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// import '../../../models/chatmessage.dart';
// import '../../../models/contectpagemodel.dart';
//
// class MessageController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final List<UserData1> userData = <UserData1>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCurrentUserLastMessages();
//   }
//
//   Future<void> fetchCurrentUserLastMessages() async {
//     try {
//       final user = _auth.currentUser;
//       final senderId = user?.uid;
//
//       if (senderId != null) {
//         userData.clear();
//
//         final lastMessages = await _firestore.collection('users/$senderId/chatwith').get();
//
//         print('Number of last messages: ${lastMessages.docs.length}');
//
//         final Map<String, ChatMessage> lastMessagesMap = {};
//
//         for (final doc in lastMessages.docs) {
//           final data = doc.data();
//           final lastMessage = ChatMessage.fromMap(data!);
//
//           final recipientId = lastMessage.recipientId;
//
//           if (!lastMessagesMap.containsKey(recipientId) ||
//               lastMessage.timestamp!.toDate().isAfter(
//                 lastMessagesMap[recipientId]?.timestamp?.toDate() ?? DateTime(0),
//               )) {
//             lastMessagesMap[recipientId] = lastMessage;
//           }
//         }
//
//         for (final entry in lastMessagesMap.entries) {
//           final recipientId = entry.key;
//           final lastMessage = entry.value;
//
//           final recipientData = await _firestore.collection('users').doc(recipientId).get();
//
//           if (recipientData.exists) {
//             final timestamp = lastMessage.timestamp;
//
//             if (timestamp != null) {
//               userData.add(UserData1(
//                 userUuid: recipientId,
//                 username: recipientData.get("name"),
//                 profilepicture: recipientData.get("profilepicture"),
//                 email: recipientData.get("email"),
//                 phonenumber: recipientData.get("phonenumber"),
//                 lastMessageContent: lastMessage.messageContent,
//                 lastMessageTimestamp: timestamp.toDate(),
//               ));
//             }
//           }
//         }
//
//         print('Number of user data items: ${userData.length}');
//
//         update(); // Trigger UI update
//       }
//     } catch (e) {
//       print('Failed to fetch last messages: $e');
//     }
//   }
//
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/foundation.dart' as foundation;
import '../../../models/chatmessage.dart';
import '../Chatpage/chatpage_view.dart';

class MessageController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final lastMessages = <ChatMessage>[].obs;
  var isTextInputOpen = false.obs;
  final messageEditingController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    listenForMessages();
  }

  void listenForMessages() {
    final user = _auth.currentUser;
    final senderId = user?.uid;

    if (senderId != null) {
      _firestore
          .collection('chats')
          .where('members', arrayContains: senderId)
          .snapshots()
          .listen((querySnapshot) async {
        try {
          final List<ChatMessage> newLastMessages = [];

          for (final doc in querySnapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final chatId = data['chatId'] as String;
            final members = data['members'] as List<String>;

            // Get the other user's ID
            final otherUserId = members.firstWhere((id) => id != senderId);

            // Fetch the last message in the chat
            final lastMessageSnapshot = await _firestore
                .collection('chats/$chatId/messages')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get();

            if (lastMessageSnapshot.docs.isNotEmpty) {
              final lastMessageData =
              lastMessageSnapshot.docs.first.data() as Map<String, dynamic>;
              final lastMessage = ChatMessage.fromMap(lastMessageData);

              // Fetch the other user's details
              final otherUserSnapshot =
              await _firestore.collection('users').doc(otherUserId).get();

              if (otherUserSnapshot.exists) {
                final otherUserData =
                otherUserSnapshot.data() as Map<String, dynamic>;
                final otherUserName = otherUserData['username'] as String;

                // Update last message with user details
                lastMessage.senderId = otherUserId;
                lastMessage.senderName = otherUserName;

                newLastMessages.add(lastMessage);
              }
            }
          }

          lastMessages.value = newLastMessages;
        } catch (e) {
          print('Error listening for last messages: $e');
        }
      });
    }
  }


  @override
  void onClose() {
    super.onClose();
    messageEditingController.dispose();
  }
}