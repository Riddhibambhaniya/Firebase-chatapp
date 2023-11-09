import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:get/get.dart';
import 'package:project_structure_with_getx/styles/colorconstants.dart';

import '../../../styles/text_style.dart';
import 'chatpage_controller.dart';

class ChatPage extends GetView<ChatController> {
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorConstants.black),
            onPressed: () {},
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Row(
            children: [
              ProfilePicture(
                name: 'Jhon',
                radius: 23,
                fontsize: 21,
              ),
              SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jhon Abraham',
                    style: textBolds,
                  ),
                  Text('email@gmail.com', style: textWelcomeBack),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                final isUserMessage = message.senderName == "You";
                return ListTile(
                  title: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Color(0xFF20A090) : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.messageContent,
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            )),
          ),

          // Text input for sending new messages
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
                        borderRadius: BorderRadius.circular(
                            20.0), // Set a circular border radius
                        border: Border.all(width: 0.0, color: Colors.grey),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Write your message',
                          hintStyle: textWelcomeBack,
                          contentPadding: EdgeInsets.only(
                              left: 15.0, right: 15, top: 5.0, bottom: 5.0),
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (message) {
                          // Handle sending the message
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
                      // Handle video icon press
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



