import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../My profile/myprofile_controller.dart';
import '../../My profile/myprofile_view.dart';
import '../chatpage/chatpage_controller.dart';
import '../chatpage/chatpage_view.dart';
import 'messagepage_controller.dart';

class MessagePage extends GetView<MessageController> {
  final MessageController controller = Get.put(MessageController());
  final MyProfileController controllers = Get.put(MyProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // App Bar
          AppBar(
            backgroundColor: Colors.black,
            title: Center(
              child: Text('Chats', style: TextStyle(color: Colors.white)),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(() => MyProfileView());
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Obx(() {
                    final userController = Get.find<MyProfileController>();
                    final userProfilePic =
                        userController.userProfilePic.value;
                    final userName = userController.userName.value;

                    return CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.white,
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
              ),
            ],
          ),

          // Message List
          Positioned(
            top: 120.0,
            left: 0,
            right: 0,
            child: Container( decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              color: Colors.white,
            ),
              width: 400,
              height: 1000,
              child: Obx(
                    () => controller.ongoingChats.isNotEmpty
                    ? ListView.builder(
                  itemCount: controller.ongoingChats.length,
                  itemBuilder: (context, index) {
                    return MessageCard(
                      userId: controller.ongoingChats[index],
                    );
                  },
                )
                    : Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final String userId;

  const MessageCard({
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to chat screen with selected user
        Get.to(() => ChatPage(), // Replace ChatPage with your actual chat page
            binding: BindingsBuilder(() {
              Get.put(ChatPageController())
                ..selectedUserId = userId
                ..loadMessages();
            }));
      },
      child: Card(
        child: ListTile(
          title: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData) {
                return Text('Unknown User');
              }

              String Name = snapshot.data!.get('name') ?? 'Unknown User';

              return Text(Name);
            },
          ),
        ),
      ),
    );
  }
}
