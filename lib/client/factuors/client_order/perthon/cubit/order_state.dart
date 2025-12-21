import 'package:flutter/cupertino.dart';
import '../../data/model/order_model.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final String message;

  OrderSuccess({this.message = "تم إنشاء الطلب بنجاح"});
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}

class GetOrdersSuccess extends OrderState {
  final List<OrderModel> orders;

  GetOrdersSuccess(this.orders);
}


// -------------------------------------------------------------
// 🔥 حالات التحميل – انسخ من هنا 🔥
// -------------------------------------------------------------

class FileDownloadLoading extends OrderState {
  final double progress;
  final String url;

  FileDownloadLoading(this.progress, this.url);
}

class FileDownloadSuccess extends OrderState {
  final String savedPath;
  final String url;

  FileDownloadSuccess(this.savedPath, this.url);
}

class FileDownloadError extends OrderState {
  final String message;
  final String url;

  FileDownloadError(this.message, this.url);
}
