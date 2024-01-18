import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
        storageBucket: 'gs://messaging-chatbox.appspot.com',
      ));
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

  Get.put<AuthController>(AuthController());
  runApp(const MyApp());
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print("Handling background message: $message");

  _handleMessage(message.data);

  if (message.notification != null) {
    _showNotification(message.notification!);
  }
}

void _handleMessage(Map<String, dynamic> data) {
  print("Handling message: $data");
}

void _showNotification(RemoteNotification notification) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id', 'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    notification.title ?? 'Default Title',
    notification.body ?? 'Default Body',
    platformChannelSpecifics,
  );
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
