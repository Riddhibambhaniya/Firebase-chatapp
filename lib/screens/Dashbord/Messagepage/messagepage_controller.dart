// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// import '../../../models/contectpagemodel.dart';
//
// class MessageController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final RxList<UserData1> userData = <UserData1>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCurrentUserRecentChats();
//   }
//
//   Future<void> fetchCurrentUserRecentChats() async {
//     try {
//       final user = _auth.currentUser;
//       final senderId = user?.uid;
//
//       if (senderId != null) {
//         // Clear existing data
//         userData.clear();
//
//         // Fetch recent messages where the current user is either the sender or recipient
//         final recentMessages = await _firestore
//             .collection('chats')
//             .where('members', arrayContains: senderId)
//             .orderBy('lastMessageTimestamp', descending: true)
//             .get();
//
//         // Directly use await without runInAction
//         for (final doc in recentMessages.docs) {
//           final members = doc['members'] as List<dynamic>;
//
//           final otherUserId = members[0] as String;
//
//           // Get the last message directly in the query
//           final lastMessageSnapshot = await _firestore
//               .collection('chats/${doc.id}/messages')
//               .orderBy('timestamp', descending: true)
//               .limit(1)
//               .get();
//
//           if (lastMessageSnapshot.docs.isNotEmpty) {
//             final lastMessageData =
//             lastMessageSnapshot.docs.first.data() as Map<String, dynamic>;
//             final timestamp = lastMessageData['timestamp']?.toDate();
//             final lastMessageContent = lastMessageData['messageContent'] ?? '';
//
//             userData.add(UserData1(
//               uuid: otherUserId,
//               name: lastMessageData['senderName'],
//               email: lastMessageData['senderEmail'],
//               lastMessageContent: lastMessageContent,
//               lastMessageTimestamp: timestamp,
//             ));
//           }
//         }
//       }
//     } catch (e) {
//       // Handle error
//       print('Failed to fetch recent chats: $e');
//     }
//   }
//
//
//
//
//
//   Future<Map<String, dynamic>?> fetchLastMessageData(
//       String senderId, String recipientId) async {
//     try {
//       final chatId = getConversationID(senderId, recipientId);
//       //final messagesId = get
//       final chatCollectionPath = 'chats/$chatId/messages';
//
//       final lastMessageSnapshot = await _firestore
//           .collection(chatCollectionPath)
//           .orderBy('timestamp', descending: true)
//           .limit(1)
//           .get();
//
//       if (lastMessageSnapshot.docs.isNotEmpty) {
//         final lastMessageData =
//         lastMessageSnapshot.docs.first.data() as Map<String, dynamic>;
//         final timestamp = lastMessageData['timestamp']?.toDate();
//         final lastMessageContent = lastMessageData['messageContent'] ?? '';
//
//         return {
//           'senderName': lastMessageData['senderName'],
//           'senderEmail': lastMessageData['senderEmail'],
//           'messageContent': lastMessageContent,
//           'timestamp': timestamp,
//         };
//       }
//
//       return null;
//     } catch (e) {
//       print('Failed to fetch last message data: $e');
//       return null;
//     }
//   }
//
//   String getConversationID(String userId1, String userId2) {
//     List<String> sortedIds = [userId1, userId2]..sort();
//     return sortedIds.join('_');
//   }
// }
//
//




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


import '../../../models/contectpagemodel.dart';


class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<UserData1> userData = <UserData1>[].obs;
  RxBool isLoading = true.obs;

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
        isLoading.value = true;

        final QuerySnapshot<Map<String, dynamic>> lastMessages =
        await _firestore.collection('users/$senderId/chatwith').get();

        // Clear the existing data before adding new
        userData.clear();

        for (final doc in lastMessages.docs) {
          final recipientId = doc.get('recipientId');
          final senderName = doc.get('senderName');

          // Fetch additional user details including phoneNumber
          final userDataSnapshot = await _firestore.collection('users').doc(recipientId).get();
        //  final phoneNumber = userDataSnapshot.get('phoneNumber');

          // Fetch the last message from the 'messages' subcollection
          final lastMessageSnapshot = await _firestore
              .collection('users/$senderId/chatwith/${doc.id}')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (lastMessageSnapshot.docs.isNotEmpty) {
            final lastMessageData =
            lastMessageSnapshot.docs.first.data() as Map<String, dynamic>;
            final timestamp = lastMessageData['timestamp']?.toDate();
            final lastMessageContent = lastMessageData['messageContent'] ?? '';

            userData.add(UserData1(
              uuid: recipientId,
              name: senderName,
              email: '', // Replace with the actual email or leave it empty
              lastMessageContent: lastMessageContent,
              lastMessageTimestamp: timestamp,
             // phoneNumber: phoneNumber, // Include phoneNumber
            ));
          }
        }



        userData.sort((a, b) =>
            (b.lastMessageTimestamp ?? DateTime(0))
                .compareTo(a.lastMessageTimestamp ?? DateTime(0)));
      }
    } catch (e) {
      print('Failed to fetch last messages: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
