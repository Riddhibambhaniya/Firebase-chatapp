import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/text_style.dart';
import '../../Sign inscreen/signin_controller.dart';
import '../../searchscreen/searchscreen_view.dart';
import '../chatpage/chatpage_view.dart';
import 'contactpage_controller.dart';

class UserData1 {
  final String userUuid;
  final String username;

  final String profilepicture;
  final String email;
  final String phonenumber;

  UserData1({
    required this.userUuid,
    required this.username,

    required this.profilepicture,
    required this.email,
    required this.phonenumber,
  });

}

class ContactPage extends GetView<ContactController> {
  final ContactController controller = Get.put(ContactController());
  final SignInController signInController = Get.find<SignInController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AppBar(
            backgroundColor: Colors.black,

            leading: Padding(
              padding: const EdgeInsets.only(left:24.0),
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () => Get.to(() => SearchScreen()),
              ),
            ),
            title:  Padding(
              padding: const EdgeInsets.only(left:78.0),
              child: Text('Contacts', style: TextStyle(color: Colors.white)),
            )

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

              height: MediaQuery.of(context).size.height *0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 215.0),
                    child: Text(
                      'My Contacts',
                      style: appbar2,
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<ContactController>(
                      builder: (controller) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.userList.length,
                          itemBuilder: (context, index) {
                            final userData = controller.userList[index];
                            final showHeader = index == 0 ||
                                userData.username[0] !=
                                    controller.userList[index - 1].username[0];


                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (showHeader)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 310.0),
                                    child: Text(
                                      userData.username[0],
                                      style: appbar2,
                                    ),
                                  ),
                                SizedBox(height: 10,),

                                   UserRow1(userData1: userData),

                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
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
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5, )),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right:40.0,top:5.0,bottom:5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:30.0,right:10.0,bottom:5.0),
              child: CircleAvatar(
                radius: 25.0, backgroundColor: Colors.black,
                backgroundImage: (userData1.profilepicture.isNotEmpty)
                    ? AssetImage(userData1.profilepicture)
                    : null, // Use null when there is no image
                child: (userData1.profilepicture.isEmpty)
                    ? Text(
                  userData1.username.isNotEmpty
                      ? userData1.username[0].toUpperCase()
                      : '', // Display the first letter of the username
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null, // Display nothing when there is an image
              ),

            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userData1.username, style: appbar2),
                  Text(userData1.email, style: appbar1),
                ],
              ),
            ),
          ],
        ),
      ),
    ) );
  }
}