import 'dart:io';

import 'package:app_alfardos/core/wedgit/widget_client/custom_client_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
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
            if (state is ClientOrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ClientOrderError) {
              return Center(child: Text(state.message));
            }

            if (state is ClientOrderLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final data = state.orders[index];
                  final pricing = Map<String, dynamic>.from(
                    data['client pricing'] ?? {},
                  );

                  final String orderId = data['orderId'];
                  final String product = data['prodact'] ?? 'بدون اسم';

                  double total = (pricing['total'] ?? 0).toDouble();
                  double paid = (pricing['paid'] ?? 0).toDouble();
                  double remaining = total - paid;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xffEAE0CF),
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

                        _row("ليزر", pricing['laser']),
                        _row("الخامه", pricing['material']),
                        _row("ملحوظه", pricing['note']),
                        _row("الإجمالي", total, isBold: true),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              child: const Text("ادفع عربون"),
                              onPressed: () async {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => PayDepositSheet(orderId: orderId),
                                );
                              },
                            ),



                            Text(
                              remaining <= 0 ? "خالص" : "الباقي: $remaining",
                              style: TextStyle(
                                color: remaining <= 0
                                    ? Colors.green
                                    : Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
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
          Text(title),
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
  const PayDepositSheet({required this.orderId});

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
              final picked =
              await ImagePicker().pickImage(source: ImageSource.gallery);
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
              context.read<ClientOrderCubit>().payDeposit(
                orderId: widget.orderId,
                amount: double.parse(amountCtrl.text),
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
