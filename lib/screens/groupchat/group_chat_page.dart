import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'groupchat_controller.dart';

class GroupChatPage extends GetView<GroupChatController> {
  final GroupChatController controller = Get.put(GroupChatController());

  GroupChatPage({required String groupId}) {
    controller.groupId = groupId;
    controller.loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
                  () => ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.messages[index]),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                    onSubmitted: (message) {
                      controller.sendMessage(message);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    controller.sendMessage(controller.textEditingController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
