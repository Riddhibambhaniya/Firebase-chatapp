// reset_password_binding.dart
import 'package:get/get.dart';
import 'package:project_structure_with_getx/screens/ResetPasswordScreen/resetPasswordScreen_controller.dart';


class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
  }
}
