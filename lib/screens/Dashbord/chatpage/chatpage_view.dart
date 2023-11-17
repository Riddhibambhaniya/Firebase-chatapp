import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_structure_with_getx/styles/colorconstants.dart';

import '../../../styles/text_style.dart';
import '../dashbord_view.dart';
import 'chatpage_controller.dart';

class ChatPage extends GetView<ChatController> {
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? userData = Get.arguments;
    String? displayName = userData?['name'];

    final String firstLetter = displayName?[0]?.toUpperCase() ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorConstants.black),
            onPressed: () {
              Get.to(() => DashboardScreen());
            },
          ),
        ),
        title: Row(children: [
          Column(children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    firstLetter,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName ?? '',
                      style: textBolds,
                    ),
                  ],
                ),
              ],
            ),
          ])
        ]),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                final isUserMessage = message.senderName == "You";

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUserMessage
                            ? Color(0xFF20A090)
                            : Color(0xFF797C7B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message.messageContent,
                        style: TextStyle(
                          color:
                          isUserMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // Handle settings icon press
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 0.0, color: Colors.grey),
                      ),
                      child: TextFormField(
                        controller: controller.messageEditingController,
                        decoration: InputDecoration(
                          hintText: 'Write your message',
                          hintStyle: textWelcomeBack,
                          contentPadding: EdgeInsets.only(
                            left: 15.0,
                            right: 15,
                            top: 5.0,
                            bottom: 5.0,
                          ),
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (message) {
                          // Fetch the recipient's name from the user data
                          final recipientName = userData?['name'];
                          // Call the modified sendMessage function
                          controller.sendMessage(message, recipientName);
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      // Handle camera icon press
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      // Get the message from the text form field
                      final message =
                          controller.messageEditingController.text;
                      // Fetch the recipient's name from the user data
                      final recipientName = userData?['name'];
                      // Call the modified sendMessage function with both parameters
                      controller.sendMessage(message, recipientName);
                      // Clear the text form field
                      controller.messageEditingController.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
