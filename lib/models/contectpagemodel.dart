import 'package:cloud_firestore/cloud_firestore.dart';

class UserData1 {
  final String userUuid;
  final String username;
  final String profilepicture;
  final String email;
  final int phonenumber; // Update the type to int
  late final String? lastMessageContent;
  final DateTime? lastMessageTimestamp;

  UserData1({
    required this.userUuid,
    required this.username,
    required this.profilepicture,
    required this.email,
    required this.phonenumber,
    this.lastMessageContent,
    this.lastMessageTimestamp,
  });

  factory UserData1.fromMap(Map<String, dynamic> map) {
    return UserData1(
      userUuid: map['userUuid'] ?? '',
      username: map['username'] ?? '',
      profilepicture: map['profilepicture'] ?? '',
      email: map['email'] ?? '',
      phonenumber: map['phonenumber'] ?? 0, // Default value or handle accordingly
      lastMessageContent: map['lastMessageContent'],
      lastMessageTimestamp: map['lastMessageTimestamp'] != null
          ? (map['lastMessageTimestamp'] as Timestamp).toDate()
          : null,
    );
  }
}
