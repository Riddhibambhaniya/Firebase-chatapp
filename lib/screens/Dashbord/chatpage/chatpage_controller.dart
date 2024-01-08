import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatPageController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedUserId = '';
  RxList<MessageModel> messages = <MessageModel>[].obs;
  late User currentUser;



  @override
  void onInit() {
    super.onInit();
    currentUser = _auth.currentUser!;
  }

  Future<void> loadMessages() async {
    try {
      String chatRoomId = _chatRoomId();

      // Retrieve the messages collection from Firestore
      QuerySnapshot messagesSnapshot = await _firestore
          .collection('messages')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      // Extract message information from the snapshot
      List<MessageModel> loadedMessages = messagesSnapshot.docs
          .map((messageDoc) => MessageModel.fromDocument(messageDoc))
          .toList();

      // Update the messages list
      messages.assignAll(loadedMessages);

      // Print sender names for debugging
      loadedMessages.forEach((message) {
        print('Sender Name: ${message.senderName}');
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }


  String _chatRoomId() {
    List<String> userIds = [currentUser.uid, selectedUserId];
    userIds.sort();
    return userIds.join('_');
  }

  Future<void> sendMessage(String text) async {
    try {
      String chatRoomId = _chatRoomId();

      // Fetch recipient's name
      String recipientName = await getRecipientName(selectedUserId);

      await _firestore
          .collection('messages')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': currentUser.uid,
        'senderName': currentUser.displayName ?? '', // Use sender's display name
        'recipientId': selectedUserId,
        'recipientName': recipientName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<String> getRecipientName(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Fetch recipient's name from user data
      return userData['name'] ?? '';
    } catch (e) {
      print('Error fetching recipient name: $e');
      return '';
    }
  }

}

class MessageModel {
  final String text;
  final String senderId;
  final String senderName;
  final Timestamp timestamp; // Add timestamp property

  MessageModel({
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  factory MessageModel.fromDocument(QueryDocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Add debug prints
    print('Data from Firestore: $data');

    // Check for null values and provide default values if needed
    String text = data['text'] ?? '';
    String senderId = data['senderId'] ?? '';
    String senderName = data['senderName'] ?? '';
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now(); // Provide a default timestamp

    // Add more debug prints
    print('Text: $text, SenderId: $senderId, SenderName: $senderName, Timestamp: $timestamp');

    return MessageModel(
      text: text,
      senderId: senderId,
      senderName: senderName,
      timestamp: timestamp,
    );
  }

}
