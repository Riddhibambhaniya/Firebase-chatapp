import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure_with_getx/screens/Dashbord/dashbord_view.dart';
import 'package:project_structure_with_getx/styles/colorconstants.dart';

import '../../styles/text_style.dart';

import 'myprofile_controller.dart';

class MyProfileView extends GetView<MyProfileController> {
  final MyProfileController myProfileController =
      Get.put(MyProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 278.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: ColorConstants.white),
                  onPressed: () {
                    Get.to(() => DashboardScreen());
                  },
                ),
              ),
              CircleAvatar(
                radius: 45.0,
                backgroundColor: Colors.white,
                child: Text(
                  (controller.userName.isNotEmpty)
                      ? controller.userName.value[0].toUpperCase()
                      : '',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                controller.userName.value,
                style: appbar,
              ),
              SizedBox(
                height: 50,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0),
                      child: Text(
                        "Display Name",
                        style: appbar1,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0),
                      child: Text(
                        controller.userName.value,
                        style: appbar2,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0),
                      child: Text(
                        "Email Address",
                        style: appbar1,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0),
                      child: Text(
                        controller.userEmail.value,
                        style: appbar2,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                            title: "Log Out",
                            titleStyle: textBolds,
                            middleText: "Are you sure you want to log out?",
                            middleTextStyle: appbar2,
                            textConfirm: "Yes",
                            textCancel: "No",
                            onConfirm: () {
                              controller.logOut();
                            },
                            onCancel: () {
                              Get.back();
                            },
                          );
                        },
                        child: Text("Log Out"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
