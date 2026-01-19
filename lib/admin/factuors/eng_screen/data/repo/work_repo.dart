import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/work_model.dart';

class WorkRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addWork(WorkModel work) async {
    try {
      await firestore.collection("works").add(work.toMap());
    } catch (e) {
      debugPrint("WorkRepository.addWork error: $e");
      rethrow;
    }
  }


  Future<List<WorkModel>> getWorksByOrder(String orderId) async {
    try {
      final snapshot = await firestore
          .collection("works")
          .where('orderId', isEqualTo: orderId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WorkModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint("WorkRepository.getWorksByOrder error: $e");
      throw Exception("حدث خطأ أثناء جلب الطلبات");
    }

  }

  Future<List<WorkModel>> getAllWorks() async {
    try {
      final snapshot = await firestore
          .collection("works")
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WorkModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint("WorkRepository.getAllWorks error: $e");
      return [];
    }
  }

  Future<void> deleteWork(String workId) async {
    try {
      await firestore.collection("works").doc(workId).delete();
    } catch (e) {
      debugPrint("WorkRepository.deleteWork error: $e");
      throw Exception("حدث خطأ أثناء حذف العمل");
    }

  }

}
