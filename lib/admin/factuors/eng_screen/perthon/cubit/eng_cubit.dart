import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../client/factuors/client_order/data/model/order_model.dart';
import '../../data/model/engineer_messages_model.dart';
import 'eng_state.dart';

class EngOrderCubit extends Cubit<EngOrderState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CloudinaryPublic cloudinary =
  CloudinaryPublic('dytgdp642', 'alfardos', cache: false);

  EngOrderCubit() : super(EngOrderInitial());

  StreamSubscription? _ordersSubscription;
  StreamSubscription? _messagesSubscription;

  /// ======================
  /// 📦 Orders Listener
  /// ======================
  void listenToAllOrders() {
    emit(EngOrderLoading());

    _ordersSubscription?.cancel();
    _ordersSubscription = firestore
        .collection("orders")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        final orders = snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList();
        emit(EngOrderLoaded(orders));
      },
      onError: (e) {
        emit(EngOrderError(e.toString()));
      },
    );
  }

  /// ======================
  /// ☁️ Upload Images
  /// ======================
  Future<List<String>> uploadImages(List<File> images, String folder) async {
    List<String> urls = [];

    for (final image in images) {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          resourceType: CloudinaryResourceType.Image,
          folder: folder,
        ),
      );
      urls.add(response.secureUrl);
    }

    return urls;
  }

  /// ======================
  /// 📄 Upload Files (PDF / DWG / ZIP)
  /// ======================
  Future<List<String>> uploadFiles(List<File> files, String folder) async {
    List<String> urls = [];

    for (final file in files) {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Raw,
          folder: folder,
        ),
      );
      urls.add(response.secureUrl);
    }

    return urls;
  }

  /// ======================
  /// 🧾 Review / Pricing
  /// ======================
  Future<void> sendReviewOrPricing({
    required String orderId,
    required String type,
    String? note,
    List<File>? files,
    List<File>? images,
  }) async {
    try {
      emit(EngOrderLoading());

      List<String> uploadedFiles = [];
      List<String> uploadedImages = [];

      if (files != null && files.isNotEmpty) {
        uploadedFiles = await uploadFiles(files, 'orders/$type/files');
      }

      if (images != null && images.isNotEmpty) {
        uploadedImages = await uploadImages(images, 'orders/$type/images');
      }

      await firestore.collection("orders").doc(orderId).update({
        type: {
          "note": note ?? "",
          "files": uploadedFiles,
          "images": uploadedImages,
          "engineerId": FirebaseAuth.instance.currentUser!.uid,
          "date": DateTime.now().toIso8601String(),
        }
      });

      /// 🔥 إرسال نفس البيانات داخل الشات
      await sendMessageToChat(
        orderId: orderId,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        senderType: 'engineer',
        text: note,
        images: uploadedImages,
        files: uploadedFiles,
        messageType: type,
      );

      emit(EngOrderSuccess(message: "تم رفع $type بنجاح"));
    } catch (e) {
      emit(EngOrderError(e.toString()));
    }
  }

  /// ======================
  /// ❌ Delete Order
  /// ======================
  Future<void> deleteOrder(String orderId) async {
    try {
      await firestore.collection("orders").doc(orderId).delete();
      listenToAllOrders();
    } catch (e) {
      emit(EngOrderError(e.toString()));
    }
  }

  /// ======================
  /// 💰 Pricing File
  /// ======================
  Future<void> sendPricingFile(String orderId, File file) async {
    try {
      emit(EngOrderLoading());

      final urls = await uploadFiles([file], 'orders/pricing');

      await firestore.collection("orders").doc(orderId).update({
        "pricingFile": {
          "url": urls.first,
          "engineerId": FirebaseAuth.instance.currentUser!.uid,
          "date": DateTime.now().toIso8601String(),
        }
      });

      emit(EngOrderFileUploaded(
        url: urls.first,
        type: "pricing",
      ));

      listenToAllOrders();
    } catch (e) {
      emit(EngOrderError(e.toString()));
    }
  }

  /// ======================
  /// 📐 Drawing Review
  /// ======================
  Future<void> sendDrawingReview(String orderId, File file) async {
    try {
      emit(EngOrderLoading());

      final urls = await uploadFiles([file], 'orders/drawing_review');

      await firestore.collection("orders").doc(orderId).update({
        "drawingReview": {
          "url": urls.first,
          "engineerId": FirebaseAuth.instance.currentUser!.uid,
          "date": DateTime.now().toIso8601String(),
        }
      });

      emit(EngOrderFileUploaded(
        url: urls.first,
        type: "drawingReview",
      ));

      listenToAllOrders();
    } catch (e) {
      emit(EngOrderError(e.toString()));
    }
  }

  /// ======================
  /// 👤 Client Pricing
  /// ======================
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

  /// ======================
  /// 💬 Send Message To Client Chat (FINAL)
  /// ======================
  Future<void> sendMessageToChat({
    required String orderId,
    required String senderId,
    required String senderType, // engineer | client
    String? text,
    List<String>? images,
    List<String>? files,
    required String messageType,
  }) async {
    final chatRef = firestore.collection('chats').doc(orderId);

    /// 🔑 جلب صاحب الأوردر (مهم للـ rules)
    final orderDoc =
    await firestore.collection('orders').doc(orderId).get();
    final orderUserId = orderDoc.data()?['userId'];

    await chatRef.set({
      'orderId': orderId,
      'userId': orderUserId,
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': text?.isNotEmpty == true
          ? text
          : images?.isNotEmpty == true
          ? '📷 صورة'
          : files?.isNotEmpty == true
          ? '📎 ملف'
          : '',
      'lastMessageType': messageType,
    }, SetOptions(merge: true));

    await chatRef.collection('messages').add({
      'senderId': senderId,
      'senderType': senderType,
      'text': text ?? '',
      'images': images ?? [],
      'files': files ?? [],
      'messageType': messageType,
      'createdAt': FieldValue.serverTimestamp(),
      'seenBy': {
        'client': senderType == 'client',
        'engineer': senderType == 'engineer',
      }
    });
  }

  /// ======================
  /// 📩 Engineer Messages
  /// ======================
  void listenToMessages() {
    emit(EngineerMessagesLoading());

    _messagesSubscription?.cancel();
    _messagesSubscription = firestore
        .collection('engineer_messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        final messages = snapshot.docs.map((doc) {
          return EngineerMessageModel.fromMap(
            doc.data(),
            doc.id,
          );
        }).toList();

        emit(EngineerMessagesLoaded(messages));
      },
      onError: (e) {
        emit(EngineerMessagesError(e.toString()));
      },
    );
  }

  Future<void> markMessageSeen(String messageId) async {
    await firestore
        .collection('engineer_messages')
        .doc(messageId)
        .update({'seen': true});
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }
}
