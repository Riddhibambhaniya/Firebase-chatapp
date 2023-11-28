import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/messageusermodel.dart';
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
    final myProfileController = Get.put(MyProfileController());
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.separated(
                    itemCount: controller.userData.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 15.0),
                    itemBuilder: (context, index) {
                      return UserRow(userData: controller.userData[index]);
                    },
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class UserRow extends StatelessWidget {
  final UserData userData;

  UserRow({required this.userData});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeDifference = userData.lastMessageTimestamp != null
        ? now.difference(userData.lastMessageTimestamp!)
        : Duration.zero;

    final formattedTimeDifference = _formatTimeDifference(timeDifference);

    return GestureDetector(
      onTap: () {
        Get.to(() => ChatPage(), arguments: {
          'uuid': userData.userUuid,
          'name': userData.username,
          'email': userData.details,
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: 9.0, right: 9.0, bottom: 15.0, top: 0.0),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.black,
                  backgroundImage: userData.avatar.isNotEmpty
                      ? AssetImage(userData.avatar)
                      : null,
                  child: userData.avatar.isEmpty
                      ? Text(
                    userData.username.isNotEmpty
                        ? userData.username[0].toUpperCase()
                        : '',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
              ),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userData.username, style: appbar2),
                  Text(userData.details, style: appbar1),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(formattedTimeDifference),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeDifference(Duration timeDifference) {
    if (timeDifference.inDays > 0) {
      return DateFormat.yMMMd().add_jm().format(DateTime.now().subtract(timeDifference));
    } else if (timeDifference.inHours > 0) {
      return "${timeDifference.inHours}h ago";
    } else if (timeDifference.inMinutes > 0) {
      return "${timeDifference.inMinutes} min ago";
    } else {
      return "just now";
    }
  }
}

