import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String userEmail;
  final String message;
  final Timestamp timestamp;
  final bool verified;

  MessageModel({
    required this.id,
    required this.userEmail,
    required this.message,
    required this.timestamp,
    required this.verified,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      userEmail: json['userEmail'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as Timestamp,
      verified: json['verified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userEmail': userEmail,
      'message': message,
      'timestamp': timestamp,
      'verified': verified,
    };
  }
}
