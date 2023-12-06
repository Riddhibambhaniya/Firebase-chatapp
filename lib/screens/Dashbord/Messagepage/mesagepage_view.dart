import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/contectpagemodel.dart';

import '../../../styles/text_style.dart';
import '../../My profile/myprofile_controller.dart';
import '../../My profile/myprofile_view.dart';
import '../../searchscreen/searchscreen_view.dart';

import 'messagepage_controller.dart';
import '../chatpage/chatpage_view.dart';

class MessagePage extends GetView<MessageController> {
  final MessageController controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AppBar(
            backgroundColor: Colors.black,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () => Get.to(() => SearchScreen()),
              ),
            ),
            title: Center(child: Text('HOME', style: TextStyle(color: Colors.white))),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(() => MyProfileView());
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Obx(() {
                    final userController = Get.find<MyProfileController>();
                    final userProfilePic = userController.userProfilePic.value;
                    final userName = userController.userName.value;

                    return CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.white,
                      backgroundImage: userProfilePic.isNotEmpty
                          ? AssetImage(userProfilePic)
                          : null,
                      child: userProfilePic.isEmpty
                          ? Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : '',
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
          Positioned(
            top: 120.0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Colors.white,
              ),
              width: 400,
              height: 1000,
              child: Obx(
                    () => ListView.separated(
                  itemCount: controller.userData.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15.0),
                  itemBuilder: (context, index) {
                    return UserRow(userData1: controller.userData[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserRow extends StatelessWidget {
  late final UserData1 userData1;

  UserRow({required this.userData1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the ChatPage with user details
        Get.to(() => ChatPage(), arguments: {
          'uuid': userData1.userUuid, // Assuming you have a userUuid property in UserData1
          'name': userData1.username,
          'email': userData1.email,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 40.0, top: 5.0, bottom: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 10.0, bottom: 5.0),
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.black,
                  backgroundImage: (userData1.profilepicture.isNotEmpty)
                      ? AssetImage(userData1.profilepicture)
                      : null,
                  child: (userData1.profilepicture.isEmpty)
                      ? Text(
                    userData1.username.isNotEmpty
                        ? userData1.username[0].toUpperCase()
                        : '',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userData1.username, style: appbar2),
                    Text(
                      userData1.lastMessageContent ?? '', // Display last message content
                      style: appbar1,
                    ),
                    Text(
                      userData1.lastMessageTimestamp != null
                          ? '${_formatTimestamp(userData1.lastMessageTimestamp!)} ago'
                          : '',
                      style: appbar1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    // You can use your own logic to format the timestamp as needed
    // For example, using the intl package for more sophisticated formatting
    // Here, we'll just show the minutes ago as in your existing code
    final now = DateTime.now();
    final timeDifference = now.difference(timestamp);

    return timeDifference.inMinutes > 0
        ? '${timeDifference.inMinutes} min'
        : 'just now';
  }
}