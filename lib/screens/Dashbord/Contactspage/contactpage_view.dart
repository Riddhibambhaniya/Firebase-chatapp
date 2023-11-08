import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/text_style.dart';
import 'contactpage_controller.dart';

class UserData1 {
  final String username;
  final String details;
  final String avatar;

  UserData1({
    required this.username,
    required this.details,
    required this.avatar,
  });
}

class ContactPage extends GetView<ContactController> {
  final ContactController controller = Get.put(ContactController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            child: AppBar(
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Icon(Icons.search, color: Colors.white),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    'Contacts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0, // Adjust the font size as needed
                    ),
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    // Add your action when the circular avatar is tapped.
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top:15,right: 38.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40.0, // Adjust the icon size as needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ), // Circular body with circular border
          Positioned(
              top: 120.0, // Adjust the top position to align with the app bar
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                  border: Border.all(
                    //color: Colors.grey, // Set the border color to gray
                    width: 5.0,
                  ),
                ),
                width: 300,
                height: 1000,
                child: Column(children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:188.0),
                    child: Text(
                      'My Contacts',
                      style: appbar2,
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                        shrinkWrap:true,
                        itemCount: controller.sortedUserData.length,
                        itemBuilder: (context, index) {
                          final userData = controller.sortedUserData[index];
                          // Check if the first character of the current username is different from the previous one
                          final showHeader = index == 0 ||
                              userData.username[0] !=
                                  controller
                                      .sortedUserData[index - 1].username[0];

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showHeader)
                                Padding(
                                  padding: const EdgeInsets.only(right:288.0),
                                  child: Text(
                                    userData.username[0],
                                    style: appbar2,
                                  ),
                                ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(left:18.0),
                                child: UserRow1(userData1: userData),
                              ),
                            ],
                          );
                        },
                      )),
                ]),
              ))
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage(userData1.avatar),
            ),
            SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userData1.username, style: appbar2),
                  Text(userData1.details, style: appbar1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
