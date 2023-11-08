import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure_with_getx/screens/Dashbord/dashbord_view.dart';
import 'package:project_structure_with_getx/styles/colorconstants.dart';

import '../../Firebase/auth_controller.dart';
import '../../styles/text_style.dart';

import 'myprofile_controller.dart';

class MyProfileView extends GetView<MyProfileController> {
  final MyProfileController controller = Get.put(MyProfileController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(right: 278.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorConstants.white),
            onPressed: () {
              Get.to(() => DashboardScreen());
            },
          ),
        ),
        Center(
          child: CircleAvatar(
            radius: 55.0,
            backgroundImage: AssetImage('assets/Ellipse 307 (1).jpg'),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Jhon Abraham',
          style: appbar,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '@jhonabraham',
          style: texts,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            color: Colors.white,
          ),
          width: 400,
          height: 1000,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 230.0),
                child: Text(
                  "Display Name",
                  style: appbar1,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 180.0),
                child: Text(
                  'Jhon Abraham',
                  style: appbar2,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 225.0),
                child: Text(
                  "Email Address",
                  style: appbar1,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Text(
                  'jhonabraham20@gmail.com',
                  style: appbar2,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 265.0),
                child: Text(
                  "Address",
                  style: appbar1,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 17.0),
                child: Text(
                  '33 street west subidbazar,sylhet',
                  style: appbar2,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 220.0),
                child: Text(
                  "Phone Number",
                  style: appbar1,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 180.0),
                child: Text(
                  '(320) 555-0104',
                  style: appbar2,
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 240.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // Set background color to black
                    onPrimary: Colors.white, // Set text color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Adjust the radius as needed
                    ),
                  ),
                  onPressed: () {
                    // Show a confirmation dialog
                    Get.defaultDialog(
                      title: "Log Out",titleStyle:textBolds,
                      middleText: "Are you sure you want to log out?",middleTextStyle: appbar2,
                      textConfirm: "Yes",
                      textCancel: "No",
                      onConfirm: () {
                        // Call the signOut method from the AuthController
                        controller.logOut(); // Close the dialog
                      },
                      onCancel: () {
                        Get.back(); // Close the dialog
                      },
                    );
                  },
                  child: Text("Log Out"),
                ),
              )
            ],
          ),
        )
      ]))),
    );
  }
}
