import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../chatpage/chatpage_controller.dart';

class ContactController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ContactModel> contacts = <ContactModel>[].obs;
  late User currentUser;
  RxList<String> ongoingChats = <String>[].obs;
  late ChatPageController chatPageController; // Add ChatPageController

  @override
  void onInit() {
    super.onInit();
    currentUser = _auth.currentUser!;
    chatPageController = Get.put(ChatPageController()); // Initialize ChatPageController
    loadContacts();
    fetchOngoingChats(); // Call the method to fetch ongoing chats
  }

  void loadContacts() async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

      List<ContactModel> loadedContacts = usersSnapshot.docs
          .map((userDoc) => ContactModel.fromDocument(userDoc))
          .where((contact) => contact.userId != currentUser.uid)
          .toList();

      contacts.assignAll(loadedContacts);
    } catch (e) {
      print('Error loading contacts: $e');
      // Handle the error, e.g., show a snackbar
      Get.snackbar('Error', 'Failed to load contacts. Please try again.');
    }
  }

  Future<List<String>> fetchOngoingChatsFromFirestore() async {
    try {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(currentUser.uid).get();

      if (userSnapshot.exists) {
        var ongoingChatsData = userSnapshot.get('ongoingChats');

        if (ongoingChatsData is List) {
          List<String> ongoingChats = List<String>.from(ongoingChatsData);
          return ongoingChats;
        } else {
          print('Invalid ongoingChats field: $ongoingChatsData');
          return [];
        }
      } else {
        print('User document does not exist.');
        return [];
      }
    } catch (e) {
      print('Error fetching ongoing chats: $e');
      rethrow;
    }
  }

  void fetchOngoingChats() async {
    try {
      // Fetch the ongoing chats from your data source
      List<String> ongoingChats = await fetchOngoingChatsFromFirestore();
      // Update the ongoingChats list
      this.ongoingChats.assignAll(ongoingChats);
    } catch (e) {
      print('Error fetching ongoing chats: $e');
      // Handle the error, e.g., show a snackbar
      Get.snackbar('Error', 'Failed to fetch ongoing chats. Please try again.');
    }
  }
}

class ContactModel {
  final String name;
  final String userId;

  ContactModel({
    required this.name,
    required this.userId,
  });

  factory ContactModel.fromDocument(QueryDocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    String name = data['name'] ?? 'Unknown';
    String userId = document.id;

    return ContactModel(
      name: name,
      userId: userId,
    );
  }
}
