import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/contectpagemodel.dart';


class ContactController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxList<UserData1> userList = <UserData1>[].obs;
  final RxList<UserData1> searchResults = <UserData1>[].obs;

  static const String userUuidKey = 'userUuid';

  @override
  void onInit() {
    super.onInit();
    fetchUserList();
  }

  Future<void> fetchUserList() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch the user list from Firestore
        final users = await FirebaseFirestore.instance.collection('users').get();
        print('Number of user documents: ${users.docs.length}');

        // Clear the existing list before updating
        userList.clear();

        // Add all users to the contact list
        users.docs.forEach((element) {
          // Check if the required fields exist in the document
          if (element.exists) {
            String name = element.get("name") ?? 'Default Name';
            String uuid = element.get("uuid") ?? '';
            String email = element.get("email") ?? '';
            // int phoneNumber = element.get("phonenumber") ?? 0;

            userList.add(UserData1(
              name: name,
              uuid: uuid,
              email: email,
              // phoneNumber: phoneNumber,
            ));
          }
        });

        update(); // Trigger UI update
      }
    } catch (e) {
      print('Failed to fetch user list: $e');
    }
  }







  void search(String query) {
    searchResults.clear();
    if (query.isNotEmpty) {
      searchResults.addAll(userList.where(
            (user) => user.name.toLowerCase().contains(query.toLowerCase()),
      ));
    }
  }

  void clearSearch(TextEditingController searchController) {
    searchResults.clear();
    userList.clear();
    update(); // Trigger UI update
  }
  Future<void> startChat(UserData1 otherUser) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Create a new chat session or get an existing one
        final chatId = await _getOrCreateChat(currentUser.uid, otherUser.uuid);

        print("chatId $chatId");

        // Update the 'chat_with' field for both users
        await updateChatWith(currentUser.uid, otherUser.uuid, chatId);
        await updateChatWith(otherUser.uuid, currentUser.uid, chatId);

        // Navigate to the chat page with the chat ID
        Get.toNamed('/chat', arguments: {
          'chatId': chatId,
          'name': otherUser.name,
          'uuid': otherUser.uuid,
        });
      }
    } catch (e) {
      print('Failed to start chat: $e');
    }
  }

  Future<String> _getOrCreateChat(String userId, String otherUserId) async {
    final chatId = getConversationID(userId, otherUserId);

    // Check if the chat session already exists
    final chatSnapshot =
    await FirebaseFirestore.instance.collection('chats').doc(chatId).get();

    if (!chatSnapshot.exists) {
      // Create a new chat session
      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'members': [userId, otherUserId],
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    return chatId; // Return the newly created or existing chat ID
  }

  Future<void> updateChatWith(
      String userId,
      String otherUserId,
      String chatId,
      ) async {
    try {
      final userObj = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final userName = userObj['name'];

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("chat_with")
          .doc(otherUserId)
          .set({
        'recipientId': otherUserId,
        'recipientName': userName,
        'chatId': chatId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to update chat_with: $e');
    }
  }

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? '${userID}_$peerID'
        : '${peerID}_$userID';
  }



}
