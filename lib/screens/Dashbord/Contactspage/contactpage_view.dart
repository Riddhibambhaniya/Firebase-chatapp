import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chatpage/chatpage_controller.dart';
import '../chatpage/chatpage_view.dart';
import 'contactpage_controller.dart';

class ContactPage extends GetView<ContactController> {
  final ContactController controller = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AppBar(
            backgroundColor: Colors.black,
            title: Padding(
              padding: const EdgeInsets.only(left: 78.0),
              child: Text('Contacts', style: TextStyle(color: Colors.white)),
            ),
          ),
          Positioned(
            top: 120.0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 215.0),
                    child: Text(
                      'My Contacts',
                      // style: appbar2, // You need to define appbar2 style
                    ),
                  ),
                  Expanded(
                    child: Obx(
                          () => controller.contacts.isNotEmpty
                          ? ListView.builder(
                        itemCount: controller.contacts.length,
                        itemBuilder: (context, index) {
                          return ContactCard(
                            contact: controller.contacts[index],
                            onTap: () {
                              String selectedUserId =
                                  controller.contacts[index].userId;
                              Get.to(() => ChatPage(),
                                  binding: BindingsBuilder(() {
                                    Get.put(ChatPageController())
                                      ..selectedUserId = selectedUserId
                                      ..loadMessages();
                                  }));
                            },
                            controller: controller,
                            index: index,
                          );
                        },
                      )
                          : Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
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

class ContactCard extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTap;
  final ContactController controller;
  final int index;

  const ContactCard({
    required this.contact,
    required this.onTap,
    required this.controller,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isInOngoingChats = controller.ongoingChats.contains(contact.userId);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isInOngoingChats ? Colors.green : null, // Highlight ongoing chats
        child: ListTile(
          title: Text(controller.contacts[index].name),
        ),
      ),
    );
  }
}

