import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/model/pricing_review_model.dart';
import 'pricing_review_state.dart';

class PricingReviewCubit extends Cubit<PricingReviewState> {
  PricingReviewCubit() : super(PricingReviewInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 جلب كل الاوردرات + مراجعة التسعير
  Future<void> getAllPricingReviews() async {
    emit(PricingReviewLoading());

    try {
      final querySnapshot =
      await _firestore.collection('orders').get();

      final List<PricingReviewModel> reviews = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();

        final pricingMap =
        data['client pricing'] as Map<String, dynamic>?;

        if (pricingMap != null) {
          reviews.add(
            PricingReviewModel.fromMap(
              pricingMap,
              orderId: doc.id,
            ).copyWith(
              clientName: data['name'] ?? '',
            ),
          );
        }
      }

      emit(PricingReviewLoaded(reviews));
    } catch (e) {
      emit(PricingReviewError(e.toString()));
    }
  }

  /// 🔹 تعديل العربون / الدفع (كاش أو تحويل)
  Future<void> updatePayment({
    required String orderId,
    required int newPaid,
    String? newReceipt,
    String? note,
  }) async {
    emit(PricingReviewLoading());

    try {
      final docRef = _firestore.collection('orders').doc(orderId);
      final doc = await docRef.get();

      if (!doc.exists) {
        emit(PricingReviewError('الأوردر غير موجود'));
        return;
      }

      final pricingMap =
      doc.data()!['client pricing'] as Map<String, dynamic>;

      final int total = (pricingMap['total'] ?? 0).toInt();
      final int remaining = total - newPaid;

      final updatedPricing = {
        ...pricingMap,
        'paid': newPaid,
        'lastDeposit': newPaid,
        'remaining': remaining,
        'isPaid': remaining <= 0,
        if (newReceipt != null) 'receipt': newReceipt,
        if (note != null) 'note': note,
      };

      await docRef.update({
        'client pricing': updatedPricing,
      });

      await getAllPricingReviews();
    } catch (e) {
      emit(PricingReviewError(e.toString()));
    }
  }

}
