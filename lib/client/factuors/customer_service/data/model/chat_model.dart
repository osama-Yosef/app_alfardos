import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text;
  final String senderId;
  final String senderRole;
  final DateTime createdAt;

  ChatMessage({
    required this.text,
    required this.senderId,
    required this.senderRole,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      senderId: map['senderId'],
      senderRole: map['senderRole'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
