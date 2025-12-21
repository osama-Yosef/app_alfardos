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

  ClientOrderCubit(this.userId, this.firestore) : super(ClientOrderInitial()) {
    listenToLatestOrders();
  }

  List<Map<String, dynamic>> orders = [];
  DocumentReference? _latestOrderRef;

  void listenToLatestOrders() {
    emit(ClientOrderLoading());
    firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      orders = snapshot.docs.map((doc) {
        _latestOrderRef = doc.reference;
        return doc.data();
      }).toList();
      emit(ClientOrderLoaded(orders));
    }, onError: (e) {
      emit(ClientOrderError(e.toString()));
    });
  }

  /// ===========================
  /// دفع عربون + رفع صورة الإيصال
  /// ===========================
  Future<void> payDeposit({
    required String orderId,
    required double amount,
    required File receiptImage,
  }) async {
    try {
      // رفع صورة الإيصال على كلاودناري
      final res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(receiptImage.path,
            resourceType: CloudinaryResourceType.Image,
            folder: 'orders/deposits'),
      );

      final ref = firestore.collection('orders').doc(orderId);
      final snapshot = await ref.get();
      final data = snapshot.data() ?? {};
      final pricing = Map<String, dynamic>.from(data['client pricing'] ?? {});

      double total = (pricing['total'] ?? 0).toDouble();
      double previousPaid = (pricing['paid'] ?? 0).toDouble();

      double newPaid = previousPaid + amount;
      if (newPaid > total) newPaid = total;

      await ref.update({
        'client pricing.paid': newPaid,
        'client pricing.depositReceipt': res.secureUrl,
        'client pricing.lastDeposit': amount,
      });

      // إعادة تحميل الأوردرات لتحديث الواجهة
      listenToLatestOrders();
    } catch (e) {
      debugPrint("payDeposit error: $e");
    }
  }
}
