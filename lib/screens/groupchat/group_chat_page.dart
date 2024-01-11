import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'groupchat_controller.dart';


class GroupChatPage extends GetView<GroupChatController> {
  final GroupChatController controller = Get.put(GroupChatController());
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
                    title: Text(controller.messages[index].text),
                    subtitle: Text(controller.messages[index].senderId),
                    // Add any other information you want to display for each message
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
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Send the message
                    controller.sendMessage();
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
