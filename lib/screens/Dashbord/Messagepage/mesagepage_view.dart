import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../My profile/myprofile_controller.dart';
import '../../My profile/myprofile_view.dart';
import '../chatpage/chatpage_controller.dart';
import '../chatpage/chatpage_view.dart';
import 'messagepage_controller.dart';

class MessagePage extends StatelessWidget {
  final MessageController controller = Get.put(MessageController());
  final MyProfileController controllers = Get.put(MyProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text('Chats', style: TextStyle(color: Colors.white)),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => MyProfileView());
            },
            child: Obx(() {
                final userController = Get.find<MyProfileController>();
                final userProfilePic =
                    userController.userProfilePic.value;
                final userName = userController.userName.value;

                return CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.blue,
                  backgroundImage: userProfilePic.isNotEmpty
                      ? AssetImage(userProfilePic)
                      : null,
                  child: userProfilePic.isEmpty
                      ? Text(
                    userName.isNotEmpty
                        ? userName[0].toUpperCase()
                        : '',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                      : null,
                );
              }),
            ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(controller.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Get the list of ongoing chats from the user document
          List<dynamic> ongoingChats = snapshot.data!.get('ongoingChats') ?? [];

          // Fetch user details for each ongoing chat
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where(FieldPath.documentId, whereIn: ongoingChats)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<DocumentSnapshot> users = snapshot.data!.docs;
              List<Widget> messageCards = [];

              for (var user in users) {
                String name = user['name'];
                String userId = user.id;

                messageCards.add(
                  GestureDetector(
                    onTap: () {
                      // Navigate to chat screen with selected user
                      Get.to(() => ChatPage(),
                          binding: BindingsBuilder(() {
                            Get.put(ChatPageController())
                              ..selectedUserId = RxString(userId)  // Use RxString here
                              ..loadMessages();
                          }));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(name),
                      ),
                    ),
                  ),
                );
              }

              return ListView(
                children: messageCards,
              );
            },
          );
        },
      ),
    );
  }
}
