import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

import '../model/order_model.dart';

class OrderRebo {
  final cloudinary = CloudinaryPublic('dytgdp642', 'alfardos', cache: false);
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(File file) async {
    try {
      final res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return res.secureUrl;
    } catch (e) {
      throw Exception("رفع الصورة فشل: $e");
    }
  }

  Future<String> uploadVideo(File file) async {
    try {
      final res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Video,
        ),
      );
      return res.secureUrl;
    } catch (e) {
      throw Exception("رفع الملف فشل: $e");
    }
  }

  Future<void> saveOrder(OrderModel order) async {
    await _firestore.collection("orders").add(order.toMap());
  }
}
