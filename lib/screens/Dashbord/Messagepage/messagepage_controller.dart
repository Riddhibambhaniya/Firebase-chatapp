import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../chatpage/chatpage_view.dart';

class MessageController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<String> ongoingChats = <String>[].obs;
  late User currentUser;

  @override
  void onInit() {
    super.onInit();
    currentUser = _auth.currentUser!;
    fetchOngoingChats();
  }

  void fetchOngoingChats() async {
    try {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(currentUser.uid).get();

      // Check if the 'ongoingChats' field exists in the document
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('ongoingChats')) {
        // Access 'ongoingChats' field and assign to the list
        List<String> ongoingChats = List<String>.from(userData['ongoingChats']);
        this.ongoingChats.assignAll(ongoingChats);

        // Print the ongoingChats list after assignment
        print('Ongoing Chats: $ongoingChats');
      } else {
        // Handle the case where 'ongoingChats' field does not exist
        print('Field "ongoingChats" does not exist within the DocumentSnapshot');
      }
    } catch (e) {
      // Handle the error, e.g., show a snackbar
      Get.snackbar('Error', 'Failed to fetch ongoing chats. Please try again.');
    }
  }






}
