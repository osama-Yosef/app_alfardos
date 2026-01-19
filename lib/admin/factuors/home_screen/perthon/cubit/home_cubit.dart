import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../data/model/homee_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore firestore;
  StreamSubscription<QuerySnapshot>? _subscription;

  HomeCubit(this.firestore) : super(HomeInitial());

  static const String statusInProgress = 'in_progress';
  static const String statusDone = 'done';

  void listenActiveOrders() {
    emit(HomeLoading());

    _subscription?.cancel();

    _subscription = firestore
        .collection('to_implement')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        _handleSnapshot(snapshot);
      },
      onError: (e) {
        if (!isClosed) {
          emit(HomeError(e.toString()));
        }
      },
    );
  }

  Future<void> _handleSnapshot(QuerySnapshot snapshot) async {
    final List<HomeActiveOrder> orders = [];
    int inProgressCount = 0;

    final ordersSnapshot = await firestore.collection('orders').get();
    final Map<String, Map<String, dynamic>> ordersMap = {
      for (var doc in ordersSnapshot.docs) doc.id: doc.data(),
    };

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final status = data['status'];

      if (status == statusInProgress || status == statusDone) {
        inProgressCount++;

        final orderId = data['orderId'] ?? doc.id;
        final orderData = ordersMap[orderId] ?? <String, dynamic>{};

        orders.add(
          HomeActiveOrder.fromMap({
            ...data,
            ...orderData,
          }),
        );
      }
    }

    if (isClosed) return;
    emit(HomeOrdersLoaded(orders, inProgressCount));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
