import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'chatpage_controller.dart';

class ChatPage extends GetView<ChatPageController> {
final TextEditingController _messageController = TextEditingController();
final ChatPageController controller = Get.put(ChatPageController());

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Chat with User'),
    ),
    body: Column(
      children: [
        Expanded(
          child: Obx(
                () => controller.messages.isNotEmpty
                ? ListView.builder(
              itemCount: controller.messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                return ChatMessageWidget(
                  message: message,
                  isSender: message.senderId == controller.currentUser.uid,
                );
              },
            )
                : Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  controller.sendMessage(_messageController.text);
                  _messageController.clear();
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

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isSender;

  const ChatMessageWidget({
    required this.message,
    required this.isSender,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: isSender ? Colors.white : Colors.black),
            ),
            SizedBox(height: 5.0),
            Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(color: isSender ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('HH:mm:ss ').format(dateTime);
  }
}