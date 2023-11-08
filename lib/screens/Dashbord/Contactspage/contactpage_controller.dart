import 'package:get/get.dart';

import '../Messagepage/mesagepage_view.dart';
import 'contactpage_view.dart';

class ContactController extends GetxController {
  // Define your user data as you have been doing.
  final List<UserData1> userData = [
    UserData1(username: 'Alex Linderson', details: 'Life is beautiful 👌', avatar: 'assets/Ellipse 307 (1).jpg'),
    UserData1(username: 'Team Align', details: 'Be your own hero 💪', avatar: 'assets/Ellipse 304.jpg'),
    UserData1(username: 'John Ahraham', details: 'Keep working ✍', avatar: 'assets/Ellipse 308.jpg'),
    UserData1(username: 'Sabila Sayma', details: 'Life is beautiful', avatar: 'assets/Rectangle 1093.jpg'),
    UserData1(username: 'Borsha Akther', details: 'Keep working', avatar: 'assets/Ellipse 304.jpg'),
    UserData1(username: 'Borsha Akther', details: 'Keep working', avatar: 'assets/Ellipse 304.jpg'),
    UserData1(username: 'Borsha Akther', details: 'Keep working', avatar: 'assets/Ellipse 304.jpg'),
    UserData1(username: 'Borsha Akther', details: 'Keep working', avatar: 'assets/Ellipse 304.jpg'),
    UserData1(username: 'Borsha Akther', details: 'Keep working', avatar: 'assets/Ellipse 304.jpg'),
    UserData1(username: 'Borsha Akther', details: 'Keep working', avatar: 'assets/Ellipse 304.jpg'),
    UserData1(username: 'Borsha Akther', details: 'Keep working', avatar: 'assets/Ellipse 304.jpg'),
    UserData1(username: 'Borsha Akther', details: 'Keep working', avatar: 'assets/Ellipse 304.jpg'),
    UserData1(username: 'orsha Akther', details: 'Keep working', avatar: 'assets/Ellipse 307 (1).jpg'), // Add more user data here.
  ];

  // Sort the user data by username in alphabetical order.
  List<UserData1> get sortedUserData => userData..sort((a, b) => a.username.compareTo(b.username));
}