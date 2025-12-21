import 'package:cloud_firestore/cloud_firestore.dart';

class EngineerMessageModel {
  final String id;
  final String orderId;
  final String message;
  final String type;
  final DateTime? createdAt;
  final bool seen;

  EngineerMessageModel({
    required this.id,
    required this.orderId,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.seen,
  });

  factory EngineerMessageModel.fromMap(
      Map<String, dynamic> data,
      String docId,
      ) {
    return EngineerMessageModel(
      id: docId,
      orderId: data['orderId'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      seen: data['seen'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'message': message,
      'type': type,
      'createdAt': createdAt,
      'seen': seen,
    };
  }
}
