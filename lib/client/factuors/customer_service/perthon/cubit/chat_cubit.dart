import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/model/chat_model.dart';
import 'chat_state.dart';

class OrderChatCubit extends Cubit<OrderChatState> {
  OrderChatCubit() : super(OrderChatInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  /// ===============================
  /// 🔵 Listen To Support Chat (userId)
  /// ===============================
  void listenToUserChat(String userId) {
    emit(OrderChatLoading());

    _subscription?.cancel();
    _subscription = _firestore

        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .listen(
          (snapshot) {
        final messages = snapshot.docs
            .map((e) => ChatMessage.fromMap(e.data()))
            .toList();

        emit(OrderChatLoaded(messages));
      },
      onError: (e) {
        emit(OrderChatError(e.toString()));
      },
    );
  }

  /// ===============================
  /// 🔵 Send Message (Auto Create Chat)
  /// ===============================
  Future<void> sendMessage({
    required String userId,
    required String text,
    required String senderId,
    required String senderRole,
    String? orderId,
  }) async {
    final chatRef = _firestore.collection('chats').doc(userId);

    /// Create chat if not exists
    await chatRef.set({
      'userId': userId,
      'orderId': orderId,
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': text,
    }, SetOptions(merge: true));

    /// Add message
    await chatRef.collection('messages').add({
      'text': text,
      'senderId': senderId,
      'senderRole': senderRole,
      'createdAt': FieldValue.serverTimestamp(),
      'orderId': orderId,
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
