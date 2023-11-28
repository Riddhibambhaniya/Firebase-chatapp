import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../styles/text_style.dart';
import 'forgotpassword_controller.dart';


class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  final TextEditingController emailController = TextEditingController();
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,
        title: Text('Forgot Password'),
        titleTextStyle: appbar,
      ),
      body: SafeArea(child:SingleChildScrollView(child: Column(

          children: [ SizedBox(height: 80),
            Text(
              ' Mail Address Here ',
              style: emailverification,
            ),
            SizedBox(height: 20),
            Text(
              ''' Enter the email address associated
                with your account ''',
              style:textLogIn ,maxLines: 2,
            ),
            SizedBox(height: 80),
               Padding(
                 padding: const EdgeInsets.only(right:252.0),
                 child: Text(
                  ' Email Address',
                  style: textYourEmail,
              ),
               ),

            Padding(
              padding: const EdgeInsets.only(left:22.0,right:22.0),
              child: TextField(
                controller: emailController,

              ),
            ),
            SizedBox(height: 110),
            Obx(
                  () => Container(
                    width: 340,
                    height: 50,
                    child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                               Colors.white70,
                          // Change the color based on form validation

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                onPressed: controller.isLoading() ? null : () => _resetPassword(),
                child: controller.isLoading()
                    ? CircularProgressIndicator()
                    : Text('RECOVER PASSWORD',style:  textBolds),
              ),
                  )
            ),
          ],
        ),
      )    ),
    );
  }

  void _resetPassword() async {
    final email = emailController.text.trim();

    if (email.isNotEmpty && GetUtils.isEmail(email)) {
      try {
        // Check if the user with the given email exists in your Firestore users collection
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          // If the user exists, proceed with the password reset logic
          controller.resetPassword(email);
        } else {
          Get.snackbar('Error', 'User not found', snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        print('Error checking user existence: $e');
        Get.snackbar('Error', 'Failed to check user existence', snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Error', 'Invalid email format', snackPosition: SnackPosition.BOTTOM);
    }
  }

}
