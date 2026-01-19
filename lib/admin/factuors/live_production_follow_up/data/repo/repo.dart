import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/material_entity _model.dart';

class MaterialRepository {
  final FirebaseFirestore firestore;
  MaterialRepository(this.firestore);

  CollectionReference get _ref => firestore.collection('materials');

  Stream<List<MaterialEntity>> watchMaterials() {
    return _ref.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) {
        return snapshot.docs
            .map((doc) => MaterialEntity.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        ))
            .toList();
      },
    );
  }

  Future<void> addMaterial(MaterialEntity material) async {
    await _ref.add(material.toFirestore());
  }

  Future<void> deleteMaterial(String id) async {
    await _ref.doc(id).delete();
  }
}
