import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:project_structure_with_getx/screens/splashscreen/splash_controller.dart';

import '../../utils/imagepath.dart';

class SplashView extends GetView<SplashController> {
  final controller = Get.find<SplashController>();
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
              width: 200,),

          ],
        ),
      ),
    );
  }
}
