import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../create_group/create_group_view.dart';
import 'Contactspage/contactpage_view.dart';
import 'Messagepage/mesagepage_view.dart';
import 'dashbord_controller.dart';

class DashboardScreen extends GetView<DashboardController>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            MessagePage(),
            ContactPage(),
            CreateGroupView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone),
              label: 'Contact',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1),
              label: 'CreateGroup',
            ),
          ],
        ),
      ),
    );
  }
}
