import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'client_balance_state.dart';

class ClientBalanceCubit extends Cubit<ClientBalanceState> {
  ClientBalanceCubit() : super(ClientBalanceInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadClientBalance(String userId) async {
    emit(ClientBalanceLoading());

    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('clientId', isEqualTo: userId)
          .get();

      double totalRemaining = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final pricing = data['client pricing'];

        if (pricing != null && pricing['remaining'] != null) {
          totalRemaining += (pricing['remaining'] as num).toDouble();
        }
      }

      emit(ClientBalanceSuccess(totalRemaining));
    } catch (e) {
      emit(ClientBalanceError(e.toString()));
    }
  }
}
