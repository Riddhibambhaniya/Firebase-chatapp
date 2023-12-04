import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../styles/text_style.dart';
import '../forgot password/forgotpassword_view.dart';
import 'signin_controller.dart';

class SignInPage extends GetView<SignInController> {

  final SignInController signInController = Get.find<SignInController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                      controller: emailController,
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
                  padding: const EdgeInsets.only(right: 280.0),
                  child: Text(
                    'Password',
                    style: textYourEmail,
                  ),
                ),
                Container(
                  width: 340,
                  child: TextFormField(
                    controller: passwordController,
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
                SizedBox(height: 140.0),
                Obx(() => Container(
                  width: 340,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isFormValid.value
                          ? Color(0xFF24786D)// Change the color based on form validation
                          : Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      controller.signIn();
                    },
                    child: Text('Log in', style: textBoldss),
                  ),
                )),
                SizedBox(height: 20.0),
                TextButton(
                  onPressed: () { Get.to(() => Routes.forgotpassword);},
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
