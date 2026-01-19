import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'factor_state.dart';

class ImplementCubit extends Cubit<ImplementState> {
  final FirebaseFirestore firestore;

  StreamSubscription<QuerySnapshot>? _subscription;

  ImplementCubit(this.firestore) : super(ImplementInitial());

  void listenToImplementOrders() {
    emit(ImplementLoading());

    _subscription?.cancel();
    _subscription = firestore
        .collection('to_implement')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            final orders = snapshot.docs
                .where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['status'] != 'completed';
                })
                .map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  if (!data.containsKey('eng review price')) {
                    data['eng review price'] = {};
                  }

                  if (!data.containsKey('orderDate')) {
                    data['orderDate'] = data['createdAt'] ?? Timestamp.now();
                  }

                  return {...data, 'docId': doc.id};
                })
                .toList();

            emit(ImplementLoaded(orders));
          },
          onError: (e) {
            emit(ImplementError(e.toString()));
          },
        );
  }

  Future<void> updateStatusByOrderId({
    required String orderId,
    required String newStatus,
  }) async {
    try {
      final query = await firestore
          .collection('to_implement')
          .where('orderId', isEqualTo: orderId)
          .where('status', whereIn: ['waiting_execution', 'in_progress'])
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        emit(ImplementError('الأوردر غير موجود في Firestore'));
        return;
      }

      final doc = query.docs.first;
      final data = doc.data();
      final currentStatus = data['status'] as String? ?? '';

      if (newStatus == 'in_progress' && currentStatus != 'waiting_execution') {
        emit(ImplementError('لا يمكن تحويل الأوردر إلى قيد التشغيل'));

        return;
      }

      if (newStatus == 'completed' &&
          !(currentStatus == 'waiting_execution' ||
              currentStatus == 'in_progress')) {
        emit(ImplementError('لا يمكن تنفيذ الأوردر الآن'));
        return;
      }

      await doc.reference.update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(ImplementError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
