import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String message;
  final Timestamp timestamp;

  ChatMessage({required this.senderId, required this.message, required this.timestamp});

  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    return ChatMessage(
      senderId: doc['senderId'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}