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
        .listen(

    (snapshot) {
        final orders = snapshot.docs.map((doc) {
          final order =
          OrderModel.fromFirestore(doc.data(), doc.id);

          final engReview =
          doc.data()['eng review price']
          as Map<String, dynamic>?;

          return PricingModel.fromOrder(order, engReview);
        }).toList();

        emit(SettingLoaded(orders: orders));
      },
      onError: (e) => emit(SettingError(e.toString())),
    );
  }

  // ===============================
  // تأكيد تنفيذ الأوردر
  // ===============================
  Future<void> confirmOrderForExecution({
    required String orderId,
  }) async {
    try {
      /// 1️⃣ رسالة للمهندسين
      await firestore.collection('engineer_messages').add({
        'orderId': orderId,
        'message': '📦 تم تأكيد الأوردر من العميل وجاهز للتنفيذ',
        'type': 'order_confirmed',
        'createdAt': FieldValue.serverTimestamp(),
        'seen': false,
      });

      /// 2️⃣ تحديث حالة الأوردر
      await firestore.collection('orders').doc(orderId).update({
        'status': 'confirmed',
        'confirmedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("confirmOrderForExecution error: $e");
    }
  }



  /// إنشاء Map جديدة لتسعير العميل
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
      }
    });
  }
}
