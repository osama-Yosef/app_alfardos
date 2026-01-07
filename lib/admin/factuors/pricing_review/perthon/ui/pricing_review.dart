import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cuibt/pricing_review_cubit.dart';
import '../cuibt/pricing_review_state.dart';
import '../../data/model/pricing_review_model.dart';

class PricingReviewPage extends StatelessWidget {
  const PricingReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      PricingReviewCubit()
        ..getAllPricingReviews(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'مراجعة التسعير',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<PricingReviewCubit, PricingReviewState>(
          builder: (context, state) {
            if (state is PricingReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PricingReviewLoaded) {
              if (state.reviews.isEmpty) {
                return const Center(child: Text('لا توجد مراجعات تسعير'));
              }

              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.reviews.length,
                itemBuilder: (context, index) {
                  final PricingReviewModel review = state.reviews[index];

                  return Card(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(bottom: 16.h),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 2.w),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _priceCard('الإجمالي', review.total),
                          _priceCard('المدفوع', review.paid),
                          _priceCard(
                            'المتبقي',
                            review.remaining,
                            isRemaining: true,
                          ),

                          SizedBox(height: 12.h),
                          if (review.receipt.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      Dialog(
                                        backgroundColor: Colors.black,
                                        insetPadding: EdgeInsets.zero,
                                        child: InteractiveViewer(
                                          child: Image.network(
                                            review.receipt,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  review.receipt,
                                  height: 180.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          SizedBox(height: 16.h),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.edit),
                              label: Text(
                                'تعديل الدفع',
                                style: TextStyle(
                                  fontSize: 21.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                _showEditPaymentDialog(
                                  context,
                                  review.orderId,
                                  review.paid,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is PricingReviewError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ================= PRICE CARD =================
  Widget _priceCard(String title, int value, {bool isRemaining = false}) {
    return Card(
      color: Colors.white70,
      margin: EdgeInsets.only(bottom: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              '$value ج',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isRemaining ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= EDIT PAYMENT =================
  void _showEditPaymentDialog(BuildContext context,
      String orderId,
      int currentPaid,) {
    final cubit = context.read<PricingReviewCubit>(); // ⬅️ خُد الـ Cubit هنا

    final amountController =
    TextEditingController(text: currentPaid.toString());
    final noteController = TextEditingController();
    bool isCash = true;

    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: cubit, // ⬅️ مرّر نفس الـ Cubit
          child: AlertDialog(
            title: const Text('تعديل الدفع'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'المبلغ المدفوع',
                      ),
                    ),
                    SizedBox(height: 8.h),

                    SwitchListTile(
                      title: Text(isCash ? 'كاش' : 'تحويل'),
                      value: isCash,
                      onChanged: (v) => setState(() => isCash = v),
                    ),

                    TextField(
                      controller: noteController,
                      decoration:
                      const InputDecoration(labelText: 'ملاحظة'),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                child: const Text('إلغاء'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('حفظ'),
                onPressed: () async {
                  final newPaid =
                      int.tryParse(amountController.text) ?? 0;

                  await context
                      .read<PricingReviewCubit>()
                      .updatePayment(
                    orderId: orderId,
                    newPaid: newPaid,
                    note: noteController.text,
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}