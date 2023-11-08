import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../styles/text_style.dart';
import 'signin_controller.dart'; // Import your controller

class SignInPage extends StatelessWidget {
  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 70),
                Text(
                  'Log in to Chatbox',
                  textAlign: TextAlign.center,
                  style: textBolds,
                ),
                SizedBox(height: 50),
                Text(
                  '''Welcome back! Sign in using your social 
account or email to continue us''',
                  textAlign: TextAlign.center,
                  style: textWelcomeBack,
                  maxLines: 2,
                ),
                SizedBox(height: 60.0),
                Padding(
                  padding: const EdgeInsets.only(right: 275.0),
                  child: Text(
                    'Your email',
                    style: textYourEmail,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 340,
                    child: TextFormField(
                      validator: controller
                          .validateEmail, // Use controller for validation
                      onChanged: (value) => controller.email.value = value,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.only(right: 280.0),
                  child: Text(
                    'Password',
                    style: textYourEmail,
                  ),
                ),
                Container(
                  width: 340,
                  child: TextFormField(
                    validator: controller
                        .validatePassword, // Use controller for validation
                    onChanged: (value) => controller.password.value = value,

                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                ),
                SizedBox(height: 140.0),
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
                    onPressed: () {
                      controller.signIn(); // Call the signIn method in your controller
                    },
                    child: Text('Log in', style: textBolds),
                  ),
                ),
                SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {},
                  child: Text('Forgot Password?', style: textYourEmail),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
