import 'package:cloud_firestore/cloud_firestore.dart';

class UserData1 {
  final String uuid;
  final String name;
  // final String profilepicture;
  final String email;
  // final int phoneNumber; // Update the type to int
  final String? lastMessageContent;
  final DateTime? lastMessageTimestamp;

  UserData1({
    required this.uuid,
    required this.name,
    // required this.profilepicture,
    required this.email,
    // required this.phoneNumber,
    this.lastMessageContent,
    this.lastMessageTimestamp,
  });

  factory UserData1.fromMap(Map<String, dynamic> map) {
    return UserData1(
      uuid: map['uuid'] ?? '',
      name: map['uname'] ?? '',
      // profilepicture: map['profilepicture'] ?? '',
      email: map['email'] ?? '',
      // phoneNumber: map['phoneNumber'] ?? 0, // Default value or handle accordingly
      lastMessageContent: map['lastMessageContent'] ?? '',
      lastMessageTimestamp: map['lastMessageTimestamp'] != null
          ? (map['lastMessageTimestamp'] as Timestamp).toDate()
          : null,
    );
  }
}
