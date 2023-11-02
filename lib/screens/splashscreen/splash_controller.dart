import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _simulateInitialization();
  }

  Future<void> _simulateInitialization() async {
    // Simulate some initialization process (e.g., loading data)
    await Future.delayed(Duration(seconds: 2));
    // You can optionally perform any post-initialization logic here
  }
}
