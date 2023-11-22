import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'contactpage_view.dart';

class ContactController extends GetxController {
  final List<UserData1> userList = [];
  final RxList<UserData1> searchResults = <UserData1>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserList();
  }


  Future<void> fetchUserList() async {
    try {
      // Check if the user is logged in
      if (FirebaseAuth.instance.currentUser != null) {
        final users = await FirebaseFirestore.instance.collection('users').get();
        print('Number of user documents: ${users.docs.length}');
        users.docs.forEach((element) {
          userList.add(UserData1(
              username: element.get("name") , // Provide a default value if it's nullable
              profilepicture: element.get("profilepicture"),
              userUuid: element.get("uuid"),
              email: element.get("email"),
              phonenumber: element.get("phonenumber")

          ));
        });

        update(); // Trigger UI update
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

