import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../models/chatmessage.dart';
import '../../../styles/text_style.dart';
import '../dashbord_view.dart';
import 'chatpage_controller.dart';

class ChatPage extends GetView<ChatController> {
  final TextEditingController _messageController = TextEditingController();
  final ChatController controller = Get.put(ChatController());
  bool _todaySeparatorShown = false;
  bool _yesterdaySeparatorShown = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? userData = Get.arguments;
    String? displayName = userData?['name'];
    final String? senderId = FirebaseAuth.instance.currentUser?.uid;

    final String firstLetter = displayName?[0]?.toUpperCase() ?? '';
    controller.listenForMessages(userData?['uuid']);

    bool isTodayMessage(ChatMessage message) {
      return DateTime.now().year == message.timestamp.toDate().year &&
          DateTime.now().month == message.timestamp.toDate().month &&
          DateTime.now().day == message.timestamp.toDate().day;
    }

    bool isYesterdayMessage(ChatMessage message) {
      DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
      return yesterday.year == message.timestamp.toDate().year &&
          yesterday.month == message.timestamp.toDate().month &&
          yesterday.day == message.timestamp.toDate().day;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.to(() => DashboardScreen());
            },
          ),
        ),
        title: Row(
          children: [
            Column(
              children: [
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
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final isUserMessage = message.senderId == senderId;

                    // Show the date separator for today only once
                    if (isTodayMessage(message) && !_todaySeparatorShown) {
                      _todaySeparatorShown = true;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Today',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          // Message widget
                          buildMessageWidget(message, isUserMessage),
                        ],
                      );
                    } else if (isYesterdayMessage(message) &&
                        !_yesterdaySeparatorShown) {
                      // Show the date separator for yesterday only once
                      _yesterdaySeparatorShown = true;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Yesterday',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          // Message widget
                          buildMessageWidget(message, isUserMessage),
                        ],
                      );
                    } else {
                      // Only show the message widget for other dates
                      return buildMessageWidget(message, isUserMessage);
                    }
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
                        controller: _messageController,
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
                          controller.sendMessage(userData?['uuid'], message);
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
                      controller.sendMessage(
                          userData?['uuid'], _messageController.text);
                      final user = FirebaseAuth.instance.currentUser;
                      final sentMessage = ChatMessage(
                        senderId: senderId ?? '',
                        recipientId: userData?['uuid'] ?? '',
                        messageContent: _messageController.text,
                        timestamp: Timestamp.now(),
                        senderName: user?.displayName ?? 'You',
                      );

                      controller.messages.add(sentMessage);
                      _messageController.clear();
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

  Widget buildMessageWidget(ChatMessage message, bool isUserMessage) {
    // Format the timestamp to display only the time
    String formattedTime = DateFormat.Hm().format(message.timestamp.toDate());

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isUserMessage ? Color(0xFF20A090) : Color(0xFFF2F7FB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.messageContent,
                style: TextStyle(
                  color: isUserMessage ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${message.senderName} • $formattedTime',
                style: TextStyle(
                  color: isUserMessage ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
