import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../styles/text_style.dart';
import '../../utils/imagepath.dart';
import 'on bording_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImagePath.smalllogo,
                          fit: BoxFit.fill,
                          height: 40,
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Chatbox',
                            textAlign: TextAlign.center,
                            style: texts,
                          ),
                        )
                      ],
                    ), // Replace with your logo asset
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 335,
                  child: Column(
                    children: [
                      Text('Connect friends', style: textss),
                      Text(' easily & quickly', style: textss),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 60.0),
                  child: Text(
                    '''Our chat app is the perfect way to stay
connected with friends and family.''',
                    style: textLogIn,
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  width: 340,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Future.delayed(Duration.zero, () {
                        Get.toNamed(Routes.signup); // Navigate to the sign-up page
                      });
                    },
                    child: Text('Sign up withn mail', style: textBolds),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 260,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Existing account? Log in',
                        style: textLogIn,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed( Routes.login);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('Log In', style: texts),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
