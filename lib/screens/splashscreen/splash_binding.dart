import 'package:get/get.dart';
import 'package:project_structure_with_getx/screens/splashscreen/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
