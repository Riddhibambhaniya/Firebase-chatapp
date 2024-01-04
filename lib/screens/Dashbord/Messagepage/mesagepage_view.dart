import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/contectpagemodel.dart';
import '../../../styles/text_style.dart';
import '../../My profile/myprofile_controller.dart';
import '../../My profile/myprofile_view.dart';
import '../../searchscreen/searchscreen_view.dart';
import '../chatpage/chatpage_view.dart';
import 'messagepage_controller.dart';

class MessagePage extends GetView<MessageController> {
  final MessageController controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // App Bar
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

          // Message List
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
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.userData.length,
                  itemBuilder: (context, index) {
                    final chat = controller.userData[index];
                    final userData = chat.userData;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30),
                        UserRow1(userData1: userData),
                        SizedBox(height: 20),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    },
                  );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
class UserRow1 extends StatelessWidget {
  final UserData1 userData1;

  UserRow1({required this.userData1});

  String getConversationID(String userID, String peerID) {
    print("userID $userID");
    print("peerID $peerID");
    return userID.hashCode <= peerID.hashCode
        ? '${userID}_$peerID'
        : '${peerID}_$userID';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final currentUser = FirebaseAuth.instance.currentUser;

          final chatId =
          getConversationID(userData1.uuid, currentUser?.uid ?? "");

          // Navigate to the ChatPage with user details
          Get.to(() => ChatPage(), arguments: {
            'uuid': userData1.uuid,
            'name': userData1.name,
            'email': userData1.email,
            'chatId': chatId,
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                )),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 5.0, bottom: 5.0,left:30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 30.0, right: 10.0, bottom: 5.0),
                //   child: CircleAvatar(
                //     radius: 25.0, backgroundColor: Colors.black,
                //     backgroundImage: (userData1.profilepicture.isNotEmpty)
                //         ? AssetImage(userData1.profilepicture)
                //         : null, // Use null when there is no image
                //     child: (userData1.profilepicture.isEmpty)
                //         ? Text(
                //             userData1.username.isNotEmpty
                //                 ? userData1.username[0].toUpperCase()
                //                 : '', // Display the first letter of the username
                //             style: TextStyle(
                //               fontSize: 15.0,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           )
                //         : null, // Display nothing when there is an image
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(userData1.name, style: appbar2),
                      Text(
                        userData1.lastMessageContent ?? '', // Display last message content
                        style: appbar1,
                      ),

                    ],
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
