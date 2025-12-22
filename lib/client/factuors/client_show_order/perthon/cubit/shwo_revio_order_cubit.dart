import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'shwo_revio_order_state.dart';

class ClientOrderCubit extends Cubit<ClientOrderState> {
  final String userId;
  final FirebaseFirestore firestore;

  final CloudinaryPublic cloudinary =
  CloudinaryPublic('dytgdp642', 'alfardos', cache: false);
  double totalDeposit = 0;
  double totalRemaining = 0;


  ClientOrderCubit(this.userId, this.firestore)
      : super(ClientOrderInitial()) {
    listenToLatestOrders();
  }

  List<Map<String, dynamic>> orders = [];

  void listenToLatestOrders() {
    emit(ClientOrderLoading());

    firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      orders = snapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      /// حساب إجمالي العربون
      totalDeposit = 0;
      for (var order in orders) {
        final pricing =
        Map<String, dynamic>.from(order['client pricing'] ?? {});
        totalDeposit += (pricing['paid'] ?? 0).toDouble();
        totalRemaining += (pricing['remaining'] ?? 0).toDouble();

      }

      emit(ClientOrderLoaded(orders));
    });
  }


  /// ======================================
  /// تسجيل العربون + حساب الباقي + الحالة
  /// ======================================
  Future<void> confirmPayment({
    required String orderId,
    required String orderName,
    required double total,
    required double deposit,
    required File receiptImage,
  }) async {
    try {
      final res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          receiptImage.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'orders/payments',
        ),
      );

      final ref = firestore.collection('orders').doc(orderId);
      final snapshot = await ref.get();
      final data = snapshot.data() ?? {};

      final pricing =
      Map<String, dynamic>.from(data['client pricing'] ?? {});

      double previousPaid = (pricing['paid'] ?? 0).toDouble();

      double newPaid = previousPaid + deposit;
      if (newPaid > total) newPaid = total;

      double remaining = total - newPaid;
      if (remaining < 0) remaining = 0;

      bool isPaid = newPaid >= total;


      await ref.update({
        /// client pricing
        'client pricing.total': total,
        'client pricing.paid': newPaid,
        'client pricing.remaining': remaining,
        'client pricing.isPaid': isPaid,
        'client pricing.lastDeposit': deposit,
        'client pricing.receipt': res.secureUrl,

        'paymentSummary': {
          'orderName': orderName,
          'deposit': deposit,
          'remaining': remaining,
          'isPaid': isPaid,
          'status': isPaid ? 'خالص' : 'عليه باقي',
          'paidAt': FieldValue.serverTimestamp(),
        }
      });

      listenToLatestOrders();
    } catch (e) {
      debugPrint('confirmPayment error: $e');
    }
  }
}
