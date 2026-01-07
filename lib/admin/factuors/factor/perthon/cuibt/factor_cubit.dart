import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'factor_state.dart';

class ImplementCubit extends Cubit<ImplementState> {
  final FirebaseFirestore firestore;

  ImplementCubit(this.firestore) : super(ImplementInitial());

  // دالة لسحب الأوردرات مباشرة من Firestore
  void listenToImplementOrders() {
    emit(ImplementLoading());

    firestore
        .collection('to_implement')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final orders =
      snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();

      emit(ImplementLoaded(orders));
    }, onError: (e) {
      emit(ImplementError(e.toString()));
    });
  }

  // دالة لتحديث حالة الأوردر
  Future<void> updateStatus(String docId, String status) async {
    await firestore.collection('to_implement').doc(docId).update({
      'status': status,
    });
  }
}
