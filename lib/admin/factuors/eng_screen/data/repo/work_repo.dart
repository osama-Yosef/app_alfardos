import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/work_model.dart';

class WorkRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addWork(WorkModel work) async {
    await firestore.collection("works").add(work.toMap());
  }

  Future<List<WorkModel>> getWorksByOrder(String orderId) async {
    final snapshot = await firestore
        .collection("works")
        .where('orderId', isEqualTo: orderId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => WorkModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<WorkModel>> getAllWorks() async {
    final snapshot = await firestore
        .collection("works")
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => WorkModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deleteWork(String workId) async {
    await firestore.collection("works").doc(workId).delete();
  }
}
