import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/model/model_prise.dart';
import '../../../../../client/factuors/client_order/data/model/order_model.dart';
import 'pricing_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final FirebaseFirestore firestore;
  StreamSubscription<QuerySnapshot>? _ordersSub;

  SettingCubit(this.firestore) : super(SettingInitial());

  // ===============================
  // الاستماع للطلبات + مراجعة المهندس
  // ===============================
  void listenToOrders() {
    emit(SettingLoading());

    _ordersSub?.cancel(); // 🔴 مهم جدًا

    _ordersSub = firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final orders = snapshot.docs.map((doc) {
        final data = doc.data();

        if (!data.containsKey('eng review price')) return null;

        final engReviewRaw = data['eng review price'];
        if (engReviewRaw is! Map<String, dynamic>) return null;

        final order = OrderModel.fromFirestore(data, doc.id);
        return PricingModel.fromOrder(order, engReviewRaw);
      }).whereType<PricingModel>().toList();

      emit(SettingLoaded(orders: orders));
    }, onError: (e) {
      emit(SettingError(e.toString()));
    });
  }

  // ===============================
  // تأكيد تنفيذ الأوردر
  // ===============================
  Future<void> confirmOrderForExecution({
    required String orderId,
  }) async {
    try {
      final orderRef = firestore.collection('orders').doc(orderId);
      final orderDoc = await orderRef.get();

      if (!orderDoc.exists) {
        throw Exception('Order not found');
      }

      final orderData = orderDoc.data()!;
      final engReview = orderData['eng review price'];

      if (engReview is! Map<String, dynamic>) {
        throw Exception('Invalid eng review price');
      }

      await firestore.collection('to_implement').add({
        'orderId': orderId,
        'clientId': orderData['userId'] ?? '',
        'name': orderData['name'] ?? '',
        'orderDate': orderData['createdAt'],
        'eng review price': {
          'date': engReview['date'],
          'engineerId': engReview['engineerId'],
          'files': List<String>.from(engReview['files'] ?? []),
          'images': List<String>.from(engReview['images'] ?? []),
          'note': engReview['note'] ?? '',
        },
        'status': 'waiting_execution',
        'executionDate': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await orderRef.update({'status': 'execution'});

      emit(ConfirmOrderSuccess());
    } catch (e) {
      emit(ConfirmOrderFailure(e.toString()));
    }
  }

  // ===============================
  // إضافة تسعير العميل
  // ===============================
  Future<void> addPricingClient({
    required String orderId,
    required int totalPrice,
    required int materialPrice,
    required int laserPrice,
    required String dateOfReceipt,
    String? noteClient,
  }) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'client pricing': {
          'total': totalPrice,
          'material': materialPrice,
          'laser': laserPrice,
          'note': noteClient ?? '',
          'date': DateTime.now().toIso8601String(),
          'dateOfReceipt': dateOfReceipt,
          'paid': 0,
          'remaining': totalPrice,
          'isPaid': false,
        },
      });
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _ordersSub?.cancel();
    return super.close();
  }
}
