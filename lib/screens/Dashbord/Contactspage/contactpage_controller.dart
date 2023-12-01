import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<String?> getUserUuid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUuidKey);
  }

  Future<void> storeUserUuid(String userUuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userUuidKey, userUuid);
  }

  Future<void> fetchUserList() async {
    try {
      final String? userUuid = await getUserUuid();

      // If userUuid is null, create and store a new one
      if (userUuid == null) {
        final newUserUuid = 'new_user_uuid'; // Replace with your logic to generate a new userUuid
        await storeUserUuid(newUserUuid);

        // Now you can use newUserUuid in your Firestore queries or wherever needed
        // ...

      } else {
        // Use the stored userUuid in your Firestore queries or wherever needed
        // ...

        if (_auth.currentUser != null) {
          final users = await FirebaseFirestore.instance.collection('users').get();

          users.docs.forEach((element) {
            userList.add(UserData1(
              userUuid: element.get("uuid"),
              username: element.get("name"),
              profilepicture: element.get("profilepicture"),
              email: element.get("email"),
              phonenumber: element.get("phonenumber"),
            ));
          });

          update(); // Trigger UI update
        }
      }
    } catch (e) {
      print('Failed to fetch user list: $e');
    }
  }

  void search(String query) {
    searchResults.clear();
    if (query.isEmpty) {
    } else {
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
}
