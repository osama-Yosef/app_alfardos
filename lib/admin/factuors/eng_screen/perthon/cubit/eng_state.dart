import 'package:flutter/foundation.dart';
import '../../../../../client/factuors/client_order/data/model/order_model.dart';
import '../../data/model/engineer_messages_model.dart';

@immutable
abstract class EngOrderState {}

class EngOrderInitial extends EngOrderState {}

class EngOrderLoading extends EngOrderState {}

class EngOrderLoaded extends EngOrderState {
  final List<OrderModel> orders;
  EngOrderLoaded(this.orders);
}

class EngOrderSuccess extends EngOrderState {
  final String? message;
  EngOrderSuccess({this.message});
}

class EngOrderError extends EngOrderState {
  final String message;
  EngOrderError(this.message);
}

class EngOrderFileUploaded extends EngOrderState {
  final String url;
  final String type;
  EngOrderFileUploaded({
    required this.url,
    required this.type,
  });
}

/// ======================
/// 📩 Engineer Messages
/// ======================

class EngineerMessagesInitial extends EngOrderState {}

class EngineerMessagesLoading extends EngOrderState {}

class EngineerMessagesLoaded extends EngOrderState {
  final List<EngineerMessageModel> messages;
  EngineerMessagesLoaded(this.messages);
}

class EngineerMessagesError extends EngOrderState {
  final String message;
  EngineerMessagesError(this.message);
}
