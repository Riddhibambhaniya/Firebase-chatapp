import 'package:get/get.dart';

import 'mesagepage_view.dart';

class MessageController extends GetxController {
  final List<UserData> userData = [
    UserData(username: 'Alex Linderson', details: 'How are you today?', avatar: 'assets/Ellipse 307 (1).jpg',),

    UserData(username: 'Team Align', details: 'How are you today?', avatar: 'assets/Ellipse 304.jpg',),
    UserData(username: 'John Ahraham', details: 'Don’t miss to attend the meeting.', avatar: 'assets/Ellipse 308.jpg'),
    UserData(username: 'Sabila Sayma', details: 'Don’t miss to attend the meeting.', avatar: 'assets/Rectangle 1093.jpg'),
    UserData(username: 'John Borino', details: 'How are you today?', avatar: 'assets/Ellipse 304.jpg'),
    UserData(username: 'Borsha Akther', details: 'Don’t miss to attend the meeting.', avatar: 'assets/Ellipse 307 (1).jpg'),
    UserData(username: 'johar khan', details: 'Don’t miss to attend the meeting.', avatar: 'assets/Ellipse 308.jpg'),
    UserData(username: 'somaya  ', details: 'How are you today?', avatar: 'assets/Rectangle 1093.jpg'),// Add more user data here.
  ];
}
