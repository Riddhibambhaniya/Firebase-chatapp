import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:project_structure_with_getx/screens/Dashbord/chatpage/chatpage_controller.dart';

import '../../groupchat/group_chat_page.dart';
import '../chatpage/chatpage_view.dart';

class ContactController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxSet<String> selectedUsers = <String>{}.obs;
  RxList<ContactModel> contacts = <ContactModel>[].obs;
  late User currentUser;
  RxList<String> ongoingChats = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    currentUser = _auth.currentUser!;
    loadContacts();
  }

  void loadContacts() async {
    try {
      QuerySnapshot usersSnapshot = await firestore.collection('users').get();

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

  Future<void> addToOngoingChats(String selectedUserId) async {
    try {
      // Check if the user is not already in ongoingChats list
      if (!ongoingChats.contains(selectedUserId)) {
        await firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'ongoingChats': FieldValue.arrayUnion([selectedUserId]),
        });
        // ongoingChats.add(selectedUserId); // Add to local list
      }
    } catch (e) {
      print('Error adding user to ongoing chats: $e');
    }
  }


  void navigateToChat(String selectedUserId) {
    // Check if the user is not already in ongoingChats list
    if (!ongoingChats.contains(selectedUserId)) {
      addToOngoingChats(selectedUserId);
    }

    Get.to(() => ChatPage(),
        // binding: BindingsBuilder(() {
        //   Get.put(ChatPageController())
        //     ..currentUser = currentUser
        //     ..selectedUserId = RxString(selectedUserId)
        //     ..loadMessages();
        // })
    );
  }

  void createGroup() {
    if (selectedUsers.isNotEmpty) {
      // Create a new group in the database and get the group ID
      String groupId = firestore.collection('groups').doc().id;

      // Add selected users to the group members list
      firestore.collection('groups').doc(groupId).set({
        'members': selectedUsers.toList(),
      });

      // Navigate to the group page
      Get.to(() => GroupChatPage(groupId: groupId));
    } else {
      Get.snackbar('Error', 'Please select at least one user to create a group.');
    }
  }



  void toggleUserSelection(String userId, bool isSelected) {
    if (isSelected) {
      selectedUsers.add(userId);
    } else {
      selectedUsers.remove(userId);
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
