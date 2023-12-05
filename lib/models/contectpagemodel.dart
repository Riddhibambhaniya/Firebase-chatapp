class UserData1 {
  final String userUuid;
  final String username;
  final String profilepicture;
  final String email;
  final String phonenumber;
  final String? lastMessageContent; // New property for the last message content
  final DateTime? lastMessageTimestamp; // New property for the last message timestamp

  UserData1({
    required this.userUuid,
    required this.username,
    required this.profilepicture,
    required this.email,
    required this.phonenumber,
    this.lastMessageContent,
    this.lastMessageTimestamp,
  });
}
