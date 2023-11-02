import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:project_structure_with_getx/screens/splashscreen/splash_controller.dart';

import '../../utils/imagepath.dart'; // Import the ImagePath class

class SplashView extends GetView<SplashController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.logo,
              fit: BoxFit.fill,
              height: 200,
              width: 200,), // Use the image path from ImagePath class

          ],
        ),
      ),
    );
  }
}
