class UserData {
  final String userUuid;
  final String username;
  final String details;
  final String avatar;
  final DateTime? lastMessageTimestamp; // Make timestamp nullable

  UserData({
    required this.userUuid,
    required this.username,
    required this.details,
    required this.avatar,
    required this.lastMessageTimestamp,
  });
}
