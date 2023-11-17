import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/text_style.dart';
import '../../My profile/myprofile_view.dart';
import 'messagepage_controller.dart';

class UserData{
  final String username;
  final String details;
  final String avatar;

  UserData({
    required this.username,
    required this.details,
    required this.avatar,
  });
}

class MessagePage extends GetView<MessageController> {
  final MessageController controller = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.black,
      body: Stack(
        children: [
          AppBar(
            backgroundColor: Colors.black, // Set the app bar background color to black

            leading: Padding(
              padding: const EdgeInsets.only(left:24.0),
              child: Icon(Icons.search, color: Colors.white),
            ),
            title: Center(child: Text('HOME', style: TextStyle(color: Colors.white))),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(() => MyProfileView());      // Add your action when the circular avatar is tapped.
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Container(
                    child: CircleAvatar(
                      radius:25.0,
                      backgroundImage: AssetImage('assets/Ellipse 307 (1).jpg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

              ),
              width:400,
              height: 1000,
              child: ListView.builder(
                itemCount: controller.userData.length,
                itemBuilder: (context, index) {
                  return UserRow(userData: controller.userData[index]);
                },
              ),
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
    return  Padding(
      padding: const EdgeInsets.only(left:9.0,right:9.0,bottom:15.0,top:0.0),
      child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:5.0),
                child: CircleAvatar(
                  radius: 31.0,
                  backgroundImage: AssetImage(userData.avatar),
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
                padding: const EdgeInsets.only(right:8.0),
                child: Text('2 min ago'),
              ),
            ],
          ),

      ),
    );
  }
}