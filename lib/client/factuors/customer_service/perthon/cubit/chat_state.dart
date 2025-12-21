import '../../data/model/chat_model.dart';

abstract class OrderChatState {}

class OrderChatInitial extends OrderChatState {}

class OrderChatLoading extends OrderChatState {}

class OrderChatLoaded extends OrderChatState {
  final List<ChatMessage> messages;
  OrderChatLoaded(this.messages);
}

class OrderChatError extends OrderChatState {
  final String error;
  OrderChatError(this.error);
}
