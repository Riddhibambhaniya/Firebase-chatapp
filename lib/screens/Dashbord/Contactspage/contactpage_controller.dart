import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/contectpagemodel.dart';
import '../../../models/chatmessage.dart'; // Assuming you have a ChatMessage model

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
      if (FirebaseAuth.instance.currentUser != null) {
        final users =
        await FirebaseFirestore.instance.collection('users').get();
        print('Number of user documents: ${users.docs.length}');
        users.docs.forEach((element) {
          userList.add(UserData1(
              username: element.get("name"),
              profilepicture: element.get("profilepicture"),
              userUuid: element.get("uuid"),
              email: element.get("email"),
              phonenumber: element.get("phonenumber")
          )
          );
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
            (user) => user.username.toLowerCase().contains(query.toLowerCase()),
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
        final chatId = await _getOrCreateChat(currentUser.uid, otherUser.userUuid);

        // Navigate to the chat page with the chat ID
        Get.toNamed('/chat', arguments: {'chatId': chatId});
      }
    } catch (e) {
      print('Failed to start chat: $e');
    }
  }

  Future<String> _getOrCreateChat(String userId, String otherUserId) async {
    // Sort user IDs to create a consistent chat ID
    final sortedIds = [userId, otherUserId]..sort();
    final chatId = sortedIds.join('_');

    // Check if the chat session already exists
    final chatSnapshot =
    await FirebaseFirestore.instance.collection('chats').doc(chatId).get();

    if (chatSnapshot.exists) {
      return chatId; // Return existing chat ID
    } else {
      // Create a new chat session
      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'members': [userId, otherUserId],
        'created_at': FieldValue.serverTimestamp(),
      });

      return chatId; // Return the newly created chat ID
    }
  }
}
