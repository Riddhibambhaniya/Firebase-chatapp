import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../styles/text_style.dart';
import 'otpscreen_controller.dart';

class OtpScreenView extends GetView<OtpScreenController> {
  final OtpScreenController controller = Get.put(OtpScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Email Verification'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80),
              Text(
                ' Get Your Code ',
                style: emailverification,
              ),
              SizedBox(height: 20),
              Text(
                'Please enter the 6 digit code that send to your email address.',
                style: textLogIn,
                maxLines: 2,
              ),
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: OtpTextField(),
              ),
              SizedBox(height: 20),
              Text(
                ' If you do not receive code! Resend',
                style: textLogIn,
              ),
              SizedBox(height: 50),
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
                  onPressed: () => OtpScreenController.to.verifyOtp(),
                  child: Text('Verify and Proceed ', style: textBolds),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OtpTextField extends GetView<OtpScreenController> {
  final OtpScreenController controller = Get.put(OtpScreenController());

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      onChanged: (value) => controller.onOtpChanged(value),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.black,
        inactiveFillColor: Colors.grey[300],
        selectedFillColor: Colors.grey[300],
        activeColor: Colors.black,
        inactiveColor: Colors.black,
        selectedColor: Colors.black,
        borderWidth: 1,
      ),
    );
  }
}
