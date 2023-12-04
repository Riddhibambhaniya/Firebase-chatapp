import 'package:get/get.dart';
import 'package:project_structure_with_getx/screens/on%20bordingscreen/on%20bording_binding.dart';
import 'package:project_structure_with_getx/screens/on%20bordingscreen/on%20bording_view.dart';
import 'package:project_structure_with_getx/screens/Dashbord/dashbord_binding.dart';
import 'package:project_structure_with_getx/screens/Dashbord/dashbord_view.dart';
import 'package:project_structure_with_getx/screens/Sign%20inscreen/signin_binding.dart';
import 'package:project_structure_with_getx/screens/Sign%20inscreen/signin_view.dart';
import 'package:project_structure_with_getx/screens/signup%20screen/signup_binding.dart';
import 'package:project_structure_with_getx/screens/signup%20screen/signup_view.dart';
import 'package:project_structure_with_getx/screens/splashscreen/splash_binding.dart';
import 'package:project_structure_with_getx/screens/splashscreen/splashscreen_view.dart';

import '../Firebase/auth_binding.dart';
import '../screens/Dashbord/chatpage/chatpage_binding.dart';
import '../screens/Dashbord/chatpage/chatpage_view.dart';
import '../screens/My profile/myprofile_binding.dart';
import '../screens/My profile/myprofile_view.dart';
import '../screens/forgot password/forgotpassword_binding.dart';
import '../screens/forgot password/forgotpassword_view.dart';
import '../screens/searchscreen/searchscreen_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => OnboardingScreen(),
      // binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: Routes.forgotpassword, // You can define a constant for the route name in app_routes.dart
      page: () => ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(), // Don't forget to create a binding for the ForgotPasswordScreen if needed
    ),
    GetPage(
      name: Routes.signup,
      page: () => SignUpPage(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.myprofile,
      page: () => MyProfileView(),
      binding: MyProfileBinding(),
    ),
    GetPage(name: Routes.searchscreen,
        page:()=> SearchScreen(),
    ),
    GetPage(
      name: Routes.Chatpage,
      page: () => ChatPage(),
      binding: ChatBinding(),
    ),
  ];
}