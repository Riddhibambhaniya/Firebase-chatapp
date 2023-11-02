import 'package:get/get.dart';

import '../screens/splashscreen/splash_binding.dart';
import '../screens/splashscreen/splashscreen_view.dart';

class AppPages {
  static const initial = '/splash';
  static final routes = [
    GetPage(
      name: initial,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),

  ];
}
