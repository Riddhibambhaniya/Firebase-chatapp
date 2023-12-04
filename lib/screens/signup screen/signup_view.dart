import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../styles/text_style.dart';
import 'signup_controller.dart';



class SignUpPage extends GetView<SignUpController> {


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
                  'Sign up with Email',
                  textAlign: TextAlign.center,
                  style: textBolds,
                ),
                SizedBox(height: 50),
                Text(
                  '''Get chatting with friends and family today by 
signing up for our chat app!''',
                  textAlign: TextAlign.center,
                  style: textWelcomeBack,
                  maxLines: 2,
                ),
                SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.only(right: 275.0),
                  child: Text(
                    'Your name',
                    style: textYourEmail,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 340,
                    child: TextFormField(
                      controller: controller.nameController,
                      validator: controller.validateName,
                      onChanged: (value) {
                        controller.name.value = value;
                        controller.updateButtonColor();
                      },
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.only(right: 270.0),
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
                      controller: controller.emailController,
                      validator: controller.validateEmail,
                      onChanged: (value) {
                        controller.email.value = value;
                        controller.updateButtonColor();
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.only(right: 278.0),
                  child: Text(
                    'Password',
                    style: textYourEmail,
                  ),
                ),
                Container(
                  width: 340,
                  child: TextFormField(
                    controller: controller.passwordController,
                    validator: controller.validatePassword,
                    onChanged: (value) {
                      controller.password.value = value;
                      controller.updateButtonColor();
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.only(right: 225.0),
                  child: Text(
                    'Confirm Password',
                    style: textYourEmail,
                  ),
                ),
                Container(
                  width: 340,
                  child: TextFormField(
                    controller: controller.confirmPasswordController,
                    validator: controller.validateConfirmPassword,
                    onChanged: (value) {
                      controller.confirmPassword.value = value;
                      controller.updateButtonColor();
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                ),
                SizedBox(height: 100.0),
                Obx(() => Container(
                  width: 340,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isFormValid.value
                          ? Color(0xFF24786D) // Change the color based on form validation
                          : Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      controller.createAccount();
                    },
                    child: Text('Create an account', style: textBoldss),
                  ),
                )),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
