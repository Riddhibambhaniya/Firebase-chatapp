import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'on bording_controller.dart';

// View for displaying the onboarding screen
class OnboardingView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1A1A1A),
        body:SafeArea(
          child:SingleChildScrollView(
            child:Column(
              children: [
                


              ],
            )
          ),
        )
    );
  }
}
