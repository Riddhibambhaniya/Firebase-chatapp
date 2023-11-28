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
        title: Text('Forgot Password'),titleTextStyle: appbar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16),
            Obx(
                  () => ElevatedButton(
                onPressed: controller.isLoading() ? null : () => _resetPassword(),
                child: controller.isLoading()
                    ? CircularProgressIndicator()
                    : Text('RECOVER PASSWORD'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword() {
    final email = emailController.text.trim();

    if (email.isNotEmpty && GetUtils.isEmail(email)) {
      controller.resetPassword(email);
    } else {
      Get.snackbar('Error', 'Invalid email format',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
