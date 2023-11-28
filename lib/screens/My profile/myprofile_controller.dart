import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Firebase/auth_controller.dart';

class MyProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var userName = ''.obs;
  var userEmail = RxString('');

  var userProfilePic = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getUserDataFromSharedPreferences();
  }

  void updateProfileDetails({
    required String userUuid,
    required String userName,
    required String userEmail,
  }) {
    this.userName.value = userName;
    this.userEmail.value = userEmail;

    // Update shared preferences
    saveUserDataToSharedPreferences(userUuid, userName, userEmail);
  }

  Future<void> saveUserDataToSharedPreferences(
      String userUuid, String userName, String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_uuid', userUuid);
    prefs.setString('user_name', userName);
    prefs.setString('user_email', userEmail);
  }
  Future<void> updateProfile(String newDisplayName, String newEmail) async {
    final userUid = _auth.currentUser?.uid;

    if (userUid != null) {
      // Update user details in Firebase
      await FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'name': newDisplayName,

      });

      // Update local values
      userName.value = newDisplayName;


      // Update shared preferences
      saveUserDataToSharedPreferences(userUid, newDisplayName, newEmail);
    }
  }

  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? '';
    userEmail.value = prefs.getString('user_email') ?? '';
    userProfilePic.value = prefs.getString('user_profile_pic') ?? '';
  }

  void logOut() {
    authController.signOutAndNavigateToOnboarding();
  }

  void clearUserData() {}
}
