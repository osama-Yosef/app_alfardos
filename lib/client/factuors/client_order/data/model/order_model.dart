import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String name;
  final int numper;
  final String prodact;
  final String matrial;
  final int quantity;
  final String size;
  final String desc;
  final List<String> images;
  final List<String> files;
  final String userId;
  final DateTime createdAt;

  OrderModel({
    this.id = "",
    required this.name,
    required this.numper,
    required this.prodact,
    required this.matrial,
    required this.quantity,
    required this.size,
    required this.desc,
    this.images = const [],
    this.files = const [],
    required this.userId,
    required this.createdAt,
  });

  OrderModel copyWith({
    String? id,
    String? name,
    int? numper,
    String? prodact,
    String? matrial,
    int? quantity,
    String? size,
    String? desc,
    List<String>? images,
    List<String>? files,
    String? userId,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      numper: numper ?? this.numper,
      prodact: prodact ?? this.prodact,
      matrial: matrial ?? this.matrial,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      desc: desc ?? this.desc,
      images: images ?? this.images,
      files: files ?? this.files,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "numper": numper,
      "prodact": prodact,
      "matrial": matrial,
      "quantity": quantity,
      "size": size,
      "desc": desc,
      "userId": userId,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedDate = DateTime.now();

    if (map['createdAt'] is Timestamp) {
      parsedDate = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is String) {
      parsedDate = DateTime.tryParse(map['createdAt']) ?? DateTime.now();
    } else if (map['createdAt'] is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(map['createdAt']);
    }

    return OrderModel(
      id: id,
      name: map['name'] ?? "",
      numper: map['numper'] is int
          ? map['numper']
          : int.tryParse(map['numper']?.toString() ?? "") ?? 0,
      prodact: map['prodact'] ?? "",
      matrial: map['matrial'] ?? "",
      quantity: map['quantity'] is int
          ? map['quantity']
          : int.tryParse(map['quantity']?.toString() ?? "") ?? 0,
      size: map['size'] ?? "",
      desc: map['desc'] ?? "",
      images: List<String>.from(map['images'] ?? []),
      files: List<String>.from(map['files'] ?? []),
      userId: map['userId'] ?? "",
      createdAt: parsedDate,
    );
  }

  static OrderModel fromFirestore(Map<String, dynamic> data, String docId) {
    final order = OrderModel.fromMap(data, docId);
    return order;
  }
}
