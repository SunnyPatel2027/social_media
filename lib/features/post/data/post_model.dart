import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String message;
  final String username;
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.message,
    required this.username,
    required this.timestamp,
  });

  factory PostModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PostModel(
      id: doc.id,
      message: data['message'] ?? '',
      username: data['username'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
