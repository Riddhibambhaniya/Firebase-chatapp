import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ContactModel> contacts = <ContactModel>[].obs;
  late User currentUser;
  RxList<String> ongoingChats = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    currentUser = _auth.currentUser!;
    loadContacts();
    fetchOngoingChats();
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
      Get.snackbar('Error', 'Failed to load contacts. Please try again.');
    }
  }

  Future<void> fetchOngoingChats() async {
    try {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(currentUser.uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('ongoingChats')) {
          List<String> ongoingChats =
          List<String>.from(userData['ongoingChats']);
          this.ongoingChats.assignAll(ongoingChats);
          print('Ongoing Chats: $ongoingChats');
        } else {
          print('Field "ongoingChats" does not exist within the DocumentSnapshot');
          this.ongoingChats.assignAll([]);
        }
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching ongoing chats: $e');
      Get.snackbar('Error', 'Failed to fetch ongoing chats. Please try again.');
    }
  }

  void addToOngoingChats(String userId) {
    ongoingChats.add(userId);
    updateOngoingChatsInFirestore();
  }

  void updateOngoingChatsInFirestore() {
    _firestore.collection('users').doc(currentUser.uid).update({
      'ongoingChats': ongoingChats.toList(),
    });
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
