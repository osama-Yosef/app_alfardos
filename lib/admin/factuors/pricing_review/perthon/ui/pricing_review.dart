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
      create: (_) => PricingReviewCubit()..getAllPricingReviews(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'مراجعة التسعير',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isDesktop = constraints.maxWidth >= 800;

            return BlocBuilder<PricingReviewCubit, PricingReviewState>(
              builder: (context, state) {
                if (state is PricingReviewLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PricingReviewLoaded) {
                  if (state.reviews.isEmpty) {
                    return const Center(child: Text('لا توجد مراجعات تسعير'));
                  }

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 900 : double.infinity,
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.reviews.length,
                        itemBuilder: (context, index) {
                          final review = state.reviews[index];
                          return _reviewCard(context, review, isDesktop);
                        },
                      ),
                    ),
                  );
                }

                if (state is PricingReviewError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }

  // ================= REVIEW CARD =================
  Widget _reviewCard(
      BuildContext context,
      PricingReviewModel review,
      bool isDesktop,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.white70),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.clientName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10.h,),
            _priceCard('الإجمالي', review.total),
            _priceCard('المدفوع', review.paid),
            _priceCard(
              'المتبقي',
              review.remaining,
              isRemaining: true,
            ),

            const SizedBox(height: 12),

            if (review.receipt.isNotEmpty)
              _receiptImage(context, review.receipt, isDesktop),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: isDesktop ? 50 : 46,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: Text(
                  'تعديل الدفع',
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : 16,
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
  }

  // ================= PRICE CARD =================
  Widget _priceCard(String title, int value,
      {bool isRemaining = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$value ج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isRemaining ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= RECEIPT IMAGE =================
  Widget _receiptImage(
      BuildContext context, String imageUrl, bool isDesktop) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.black,
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          height: isDesktop ? 260 : 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ================= EDIT PAYMENT =================
  void _showEditPaymentDialog(
      BuildContext context,
      String orderId,
      int currentPaid,
      ) {
    final cubit = context.read<PricingReviewCubit>();

    final amountController =
    TextEditingController(text: currentPaid.toString());
    final noteController = TextEditingController();
    bool isCash = true;

    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: AlertDialog(
            title: const Text('تعديل الدفع'),
            content: SizedBox(
              width: 400,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'المبلغ المدفوع',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      SwitchListTile(
                        title: Text(isCash ? 'كاش' : 'تحويل'),
                        value: isCash,
                        onChanged: (v) => setState(() => isCash = v),
                      ),

                      TextField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          labelText: 'ملاحظة',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  );
                },
              ),
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
