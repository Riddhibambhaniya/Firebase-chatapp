import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'contactpage_view.dart';

class ContactController extends GetxController {
  final List<UserData1> userList = [];
  @override
  void onInit() {
    super.onInit();
    fetchUserList();
  }
  Future<void> fetchUserList() async {
    try {
      // Check if user is logged in
      if (FirebaseAuth.instance.currentUser != null) {
        final users = await FirebaseFirestore.instance.collection('users').get();
        users.docs.forEach((element) {
          userList.add(UserData1(username: element.get("name"),avatar: "",details: "", userUuid: ''));
        });
      }
    } catch (e) {
      print('Failed to fetch user list: $e');
    }
  }
}