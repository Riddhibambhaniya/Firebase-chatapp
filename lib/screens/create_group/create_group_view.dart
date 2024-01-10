import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../styles/text_style.dart';
import 'create_group_controller.dart';


class CreateGroupView extends GetView<CreateGroupController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group',style: appbar2,),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Group Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              // Your text field for group name goes here
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logic for 'Group Work' button
                  },
                  child: Text('Group Work'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Logic for 'Team Relationship' button
                  },
                  child: Text('Team Relationship'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Group Admin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                CircleAvatar(
                  // User profile pic goes here
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Username'),
                    Text('Group Admin'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Invited Members',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Logic for 'Create' button
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
