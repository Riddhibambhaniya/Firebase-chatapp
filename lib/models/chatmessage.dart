import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  late final String senderId;
  final String recipientId;
  final String messageContent;
  final Timestamp timestamp;
  late final String senderName;

  ChatMessage({
    required this.senderId,
    required this.recipientId,
    required this.messageContent,
    required this.timestamp,
    required this.senderName,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'] ?? '',
      recipientId: map['recipientId'] ?? '',
      messageContent: map['messageContent'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      senderName: map['senderName'] ?? '',
    );
  }
}

