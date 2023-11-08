import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../styles/text_style.dart';
import 'signup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUpPage extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

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
                      validator: controller
                          .validateName, // Use controller for validation
                      onChanged: (value) => controller.name.value = value,
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
                  padding: const EdgeInsets.only(right: 278.0),
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
                    validator: controller
                        .validateConfirmPassword, // Use controller for validation
                    onChanged: (value) => controller.confirmPassword.value = value,

                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                ),
                SizedBox(height: 100.0),
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
                  // onPressed: () {
                  //   if (controller.isValidForm) {
                  //     // Add your logic here
                  //   } else {
                  //     // Show a feedback message when the form is invalid
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(
                  //         content: Text('Please fill in all fields correctly.'),
                  //         backgroundColor: Colors.red,
                  //       ),
                  //     );
                  //   }
                  // },
                  onPressed: () async {
                    if (controller.isValidForm) {
                      try {
                        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: controller.email.value,
                          password: controller.password.value,
                        );

                        // User registration is successful
                        if (userCredential.user != null) {
                          // Save user data to Firebase Firestore
                          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                            'name': controller.name.value,
                            'email': controller.email.value,
                          });

                          // Navigate to the home screen after successful registration
                          Get.offNamed('/home');
                        } else {
                          // Handle registration error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registration failed. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        // Handle other registration errors (e.g., weak password, email already in use, etc.)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registration failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      // Show a feedback message when the form is invalid
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all fields correctly.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Create an account', style: textBolds),
                ),
              ),

              SizedBox(height: 20.0),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
