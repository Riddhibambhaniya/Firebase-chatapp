class CommonUserData {
  final String userUuid;
  final String username;
  final String details; // Add other common properties

  CommonUserData({
    required this.userUuid,
    required this.username,
    required this.details,
  });
}
class UserData extends CommonUserData {
  final String avatar;
  final DateTime? lastMessageTimestamp;

  UserData({
    required String userUuid,
    required String username,
    required String details,
    required this.avatar,
    required this.lastMessageTimestamp,
  }) : super(userUuid: userUuid, username: username, details: details);
}

class UserData1 extends CommonUserData {
  final String profilepicture;
  final String email;
  final String phonenumber;

  UserData1(this.profilepicture, {
    required String userUuid,
    required String username,
    required this.email,
    required this.phonenumber,
  }) : super(userUuid: userUuid, username: username, details: '');
}
