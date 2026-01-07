import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../data/model/model_prise.dart';
import '../../../../../client/factuors/client_order/data/model/order_model.dart';
import 'pricing_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final FirebaseFirestore firestore;

  SettingCubit(this.firestore) : super(SettingInitial());

  /// الاستماع للطلبات + قراءة مراجعة المهندس
  void listenToOrders() {
    emit(SettingLoading());

    firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          final orders = snapshot.docs.map((doc) {
            final order = OrderModel.fromFirestore(doc.data(), doc.id);

            final engReview =
                doc.data()['eng review price'] as Map<String, dynamic>?;

            return PricingModel.fromOrder(order, engReview);
          }).toList();

          emit(SettingLoaded(orders: orders));
        }, onError: (e) => emit(SettingError(e.toString())));
  }

  // ===============================
  // تأكيد تنفيذ الأوردر
  // ===============================
  Future<void> confirmOrderForExecution({required String orderId}) async {
    try {
      /// 1️⃣ جلب الأوردر
      final orderRef = firestore.collection('orders').doc(orderId);
      final orderDoc = await orderRef.get();

      if (!orderDoc.exists) {
        throw Exception("Order not found");
      }

      final orderData = orderDoc.data()!;
      final engReviewPrice = orderData['eng review price'];

      if (engReviewPrice == null) {
        throw Exception("eng review price not found");
      }

      /// 2️⃣ إنشاء أوردر في كوليكشن التنفيذ
      await firestore.collection('to_implement').add({
        'orderId': orderId,
        'clientId': orderData['userId'],
        'name': orderData['name'],
        'orderDate': orderData['createdAt'],
        'eng review price': {
          'date': engReviewPrice['date'],
          'engineerId': engReviewPrice['engineerId'],
          'files': engReviewPrice['files'] ?? [],
          'images': engReviewPrice['images'] ?? [],
          'note': engReviewPrice['note'],
        },
        'status': 'waiting_execution',
        'executionDate': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      /// 3️⃣ تحديث حالة الأوردر
      await orderRef.update({'status': 'execution'});

      /// 4️⃣ إعادة تحميل الطلبات بدون كسر الصفحة
      listenToOrders();

      emit(ConfirmOrderSuccess());
    } catch (e) {
      emit(ConfirmOrderFailure(e.toString()));
    }
  }


  void addPricingClient({
    required String orderId,
    required double totalPrice,
    required double materialPrice,
    required double laserPrice,
    String? noteClient,
  }) {
    firestore.collection('orders').doc(orderId).update({
      'client pricing': {
        'total': totalPrice,
        'material': materialPrice,
        'laser': laserPrice,
        'note': noteClient ?? '',
        'date': DateTime.now().toIso8601String(),
      },
    });
  }
}
