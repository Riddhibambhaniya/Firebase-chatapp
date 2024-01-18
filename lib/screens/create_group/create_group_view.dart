import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Dashbord/Contactspage/contactpage_controller.dart';


class CreateGroupPage extends GetView<ContactController> {
  final ContactController controller = Get.find<ContactController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Create a group with selected users
              controller.createGroup();
            },
            child: Text('Create Group'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.contacts.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(controller.contacts[index].name),
                  value: controller.selectedUsers.contains(controller.contacts[index].userId),
                  onChanged: (value) {
                    controller.toggleUserSelection(controller.contacts[index].userId, value ?? false);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
