import 'dart:io';

import 'package:app_alfardos/core/wedgit/widget_client/custom_client_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/wedgit/widget_client/instapay_launcher.dart';
import '../cubit/shwo_revio_order_cubit.dart';
import '../cubit/shwo_revio_order_state.dart';

class ClientShowOrderPage extends StatelessWidget {
  const ClientShowOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        appBar: CustomClientAppBar(),
        body: Center(child: Text('العميل غير مسجل دخول')),
      );
    }

    return BlocProvider(
      create: (_) => ClientOrderCubit(user.uid, FirebaseFirestore.instance),
      child: Scaffold(
        appBar: const CustomClientAppBar(),
        body: BlocBuilder<ClientOrderCubit, ClientOrderState>(
          builder: (context, state) {
            if (state is ClientOrderLoaded) {
              final filteredOrders = state.orders.where((order) {
                final pricing = order['client pricing'];
                return pricing != null && pricing is Map && pricing.isNotEmpty;
              }).toList();

              if (filteredOrders.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد طلبات جاهزة للعرض',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 800,

                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final data = filteredOrders[index];

                      final pricing = Map<String, dynamic>.from(
                        data['client pricing'] ?? {},
                      );

                      final String orderId = data['orderId'];
                      final String product = data['prodact'] ?? 'بدون اسم';

                      double paid = (pricing['paid'] ?? 0).toDouble();
                      double total = (pricing['total'] ?? 0).toDouble();
                      double remaining = total - paid;
                      if (remaining < 0) remaining = 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xffEAE0CF),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const Divider(height: 20),

                            _row("ليزر", pricing['laser'] ?? 0),
                            _row("الخامه", pricing['material'] ?? 0),
                            _row("ملحوظه", pricing['note'] ?? ''),
                            _row("الاجمالي", pricing['total'] ?? 0),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await openInstaPay();

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (sheetContext) {
                                        return BlocProvider.value(
                                          value: context.read<ClientOrderCubit>(),
                                          child: PayDepositSheet(
                                            orderId: orderId,
                                            orderName: product,
                                            total: total,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffE9762B),
                                    elevation: 6,
                                    shadowColor: Colors.black45,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.payments_rounded,
                                        color: Colors.lightGreen,
                                        size: 26.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "ادفع عربون",
                                        style: TextStyle(
                                          color: const Color(0xff41644A),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                buildPaymentStatus(pricing: pricing),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _row(String title, dynamic value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title :",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
              fontSize: 20.sp,
            ),
          ),
          Text(
            "$value",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class PayDepositSheet extends StatefulWidget {
  final String orderId;
  final String orderName;
  final double total;

  const PayDepositSheet({
    super.key,
    required this.orderId,
    required this.orderName,
    required this.total,
  });

  @override
  State<PayDepositSheet> createState() => _PayDepositSheetState();
}

class _PayDepositSheetState extends State<PayDepositSheet> {
  final TextEditingController amountCtrl = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'مبلغ العربون'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final picked = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (picked != null) {
                setState(() => image = File(picked.path));
              }
            },
            child: const Text("رفع صورة الإيصال"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: image == null
                ? null
                : () {
              context.read<ClientOrderCubit>().confirmPayment(
                orderId: widget.orderId,
                orderName: widget.orderName,
                total: widget.total,
                deposit: double.parse(amountCtrl.text),
                receiptImage: image!,
              );
              Navigator.pop(context);
            },
            child: const Text("تأكيد الدفع"),
          ),
        ],
      ),
    );
  }
}

Widget buildPaymentStatus({required Map<String, dynamic> pricing}) {
  final double total = (pricing['total'] ?? 0).toDouble();
  final double paid = (pricing['paid'] ?? 0).toDouble();

  if (paid <= 0) {
    return Text(
      " باقي : $total",
      style: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  final double remaining = total - paid;

  if (paid >= total && total > 0) {
    return const Text(
      "خالص",
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  return Text(
    "الباقي: $remaining",
    style: const TextStyle(
      color: Colors.redAccent,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );
}
