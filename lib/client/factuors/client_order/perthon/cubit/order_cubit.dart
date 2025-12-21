import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/model/order_model.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CloudinaryPublic cloudinary =
  CloudinaryPublic('dytgdp642', 'alfardos', cache: false);

  OrderCubit() : super(OrderInitial());

  // --------------------------------------------------------------------------
  // إنشاء الطلب مع رفع الصور والملفات
  // --------------------------------------------------------------------------
  Future<void> createOrder(
      OrderModel orderModel,
      List<File> imageFiles,
      List<File> fileFiles,
      ) async {
    try {
      emit(OrderLoading());

      List<String> imageUrls = [];
      for (var img in imageFiles) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(img.path, folder: 'orders_images'),
        );
        imageUrls.add(res.secureUrl);
      }

      List<String> filesUrls = [];
      for (var file in fileFiles) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(file.path, folder: 'orders_files'),
        );
        filesUrls.add(res.secureUrl);
      }

      final docRef = await firestore.collection("orders").add({
        ...orderModel.toMap(),
        "images": imageUrls,
        "files": filesUrls,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await docRef.update({"orderId": docRef.id});

      emit(OrderSuccess());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
//يجيب اخر اوردر اتعمل
  Future<void> listenToLastOrder(String userId) async {
    emit(OrderLoading());

    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        emit(GetOrdersSuccess([]));
      } else {
        final orders = snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList();

        emit(GetOrdersSuccess(orders));
      }
    });
  }

  // --------------------------------------------------------------------------
  // متابعة طلبات العميل
  // --------------------------------------------------------------------------
  void listenToOrders(String userId) {
    firestore
        .collection("orders")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((snapshot) {
      List<OrderModel> orders = snapshot.docs
          .map((d) => OrderModel.fromMap(d.data(), d.id))
          .toList();

      emit(GetOrdersSuccess(orders));
    });
  }

  // --------------------------------------------------------------------------
  // تحميل ملف من رابط
  // --------------------------------------------------------------------------
  Future<void> downloadFile(String url) async {
    try {
      emit(FileDownloadLoading(0.0, url));

      final dir = await getApplicationDocumentsDirectory();
      final fileName = url.split('/').last;
      final savePath = "${dir.path}/$fileName";

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            double progress = received / total;
            emit(FileDownloadLoading(progress, url));
          }
        },
      );

      emit(FileDownloadSuccess(savePath, url));

      OpenFile.open(savePath);
    } catch (e) {
      emit(FileDownloadError("حدث خطأ أثناء تحميل الملف", url));
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      emit(OrderLoading());
      await firestore.collection("orders").doc(orderId).delete();
      emit(OrderSuccess());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
