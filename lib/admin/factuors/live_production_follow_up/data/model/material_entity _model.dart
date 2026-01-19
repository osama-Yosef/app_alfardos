import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialEntity {
  final String id;
  final String name;
  final String category;
  final String unit;
  final double price;
  final String supplier;
  final double minLimit;
  final double maxLimit;

  MaterialEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
    required this.supplier,
    required this.minLimit,
    required this.maxLimit,
  });

  factory MaterialEntity.fromFirestore(String id, Map<String, dynamic> json) {
    return MaterialEntity(
      id: id,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      unit: json['unit'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      supplier: json['supplier'] ?? '',
      minLimit: (json['minLimit'] ?? 0).toDouble(),
      maxLimit: (json['maxLimit'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'unit': unit,
      'price': price,
      'supplier': supplier,
      'minLimit': minLimit,
      'maxLimit': maxLimit,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
