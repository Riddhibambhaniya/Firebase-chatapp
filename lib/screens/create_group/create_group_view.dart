import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Dashbord/Contactspage/contactpage_controller.dart';
import 'create_group_controller.dart';


class CreateGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CreateGroupController createGroupController = Get.put(CreateGroupController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: GetBuilder<ContactController>(
        builder: (contactController) {
          return ListView.builder(
            itemCount: contactController.contacts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(contactController.contacts[index].name),
                trailing: Checkbox(
                  value: createGroupController.selectedUsers.contains(contactController.contacts[index].userId),
                  onChanged: (isSelected) {
                    createGroupController.toggleUserSelection(contactController.contacts[index].userId, isSelected!);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createGroupController.createGroup();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
