import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure_with_getx/screens/ResetPasswordScreen/resetPasswordScreen_controller.dart';

import '../../styles/text_style.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {

  final String email;
  ResetPasswordScreen({required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Reset Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80),
              Text(
                ' Enter New Password ',
                style: emailverification,
              ),
              SizedBox(height: 20),
              Text(
                'Your new password must be different from previously used password ',
                style: textLogIn,
                maxLines: 2,
              ),
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(right: 252.0),
                child: Text(
                  'Old Password',
                  style: textYourEmail,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.0, right: 22),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) => controller.onOldPasswordChanged(value),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 252.0),
                child: Text(
                  'New Password',
                  style: textYourEmail,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) => controller.onNewPasswordChanged(value),
                ),
              ),
              SizedBox(height: 80),
              Container(
                width: 340,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => controller.resetPassword(),
                  child: Text('Continue', style: textBolds),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
