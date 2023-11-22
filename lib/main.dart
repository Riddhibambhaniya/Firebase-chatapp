import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure_with_getx/routes/app_pages.dart';

import 'package:project_structure_with_getx/routes/app_routes.dart';

import 'Firebase/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAf0iKjNsCLA-3KeTQyv-uXKCafYuwQYoY',
    appId: 'com.example.project_structure_with_getx',
    messagingSenderId: '875664124972',
    projectId: 'messaging-chatbox',
  ));
  Get.put<AuthController>(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
    );
  }
}
