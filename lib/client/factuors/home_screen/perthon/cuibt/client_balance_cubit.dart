import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

        if (pricing != null) {
          final remaining = pricing['remaining'];
          if (remaining is num) totalRemaining += remaining.toDouble();
        }

      }

      emit(ClientBalanceSuccess(totalRemaining));
    } catch (e) {
      emit(ClientBalanceError(e.toString()));
    }
  }

  Future<void> loadClientOrdersCount(String userId) async {
    try {
      final inProgressSnapshot = await _firestore
          .collection('to_implement')
          .where('clientId', isEqualTo: userId)
          .where('status', isEqualTo: 'in_progress')
          .get();

      final completedSnapshot = await _firestore
          .collection('to_implement')
          .where('clientId', isEqualTo: userId)
          .where('status', isEqualTo: 'completed')
          .get();

      final snapshot = await FirebaseFirestore.instance
          .collection('to_implement')
          .where('clientId', isEqualTo: userId)
          .get();

      debugPrint('TOTAL DOCS = ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        print(doc.data());
      }

      emit(
        ClientOrdersCountSuccess(
          inProgressCount: inProgressSnapshot.docs.length,
          completedCount: completedSnapshot.docs.length,
        ),
      );
    } catch (e) {
      emit(ClientBalanceError(e.toString()));
    }
  }


}
