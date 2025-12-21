import 'package:cloud_firestore/cloud_firestore.dart';

class WorkModel {
  final String id;
  final String orderId;
  final String type;
  final String note;
  final List<String> files;
  final List<String> images;
  final String engineerId;
  final DateTime date;

  WorkModel({
    this.id = "",
    required this.orderId,
    required this.type,
    required this.note,
    this.files = const [],
    this.images = const [],
    required this.engineerId,
    required this.date,
  });

  WorkModel copyWith({
    String? id,
    String? orderId,
    String? type,
    String? note,
    List<String>? files,
    List<String>? images,
    String? engineerId,
    DateTime? date,
  }) {
    return WorkModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      type: type ?? this.type,
      note: note ?? this.note,
      files: files ?? this.files,
      images: images ?? this.images,
      engineerId: engineerId ?? this.engineerId,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "type": type,
      "note": note,
      "files": files,
      "images": images,
      "engineerId": engineerId,
      "date": Timestamp.fromDate(date),
    };
  }

  factory WorkModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedDate = DateTime.now();
    if (map['date'] is Timestamp) {
      parsedDate = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is String) {
      parsedDate = DateTime.tryParse(map['date']) ?? DateTime.now();
    } else if (map['date'] is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(map['date']);
    }

    return WorkModel(
      id: id,
      orderId: map['orderId'] ?? "",
      type: map['type'] ?? "",
      note: map['note'] ?? "",
      files: (map['files'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      images: (map['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      engineerId: map['engineerId'] ?? "",
      date: parsedDate,
    );
  }
}
