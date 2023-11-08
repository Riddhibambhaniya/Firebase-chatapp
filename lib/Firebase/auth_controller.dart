import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/on bordingscreen/on bording_view.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? currentUser = userCredential.user;
      await _storeUserDataInSharedPreferences(currentUser);
      return currentUser;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> signOutAndNavigateToOnboarding() async {
    try {
      await _auth.signOut();
      clearUserData();
      Get.offAll(OnboardingScreen()); // Navigate to the OnboardingScreen
    } catch (e) {
      print("Error signing out: $e");
    }}

  Future<void> _storeUserDataInSharedPreferences(User? user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user != null) {
      prefs.setString("userUid", user.uid);
      prefs.setString("userEmail", user.email ?? "");
      // Add more user data as needed
    }
  }

  Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // You can add more code here to clear any additional user data if needed
  }

}
