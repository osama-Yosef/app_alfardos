import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/wedgit/wedgit_app/coloers.dart';
import '../cuibt/factor_cubit.dart';
import '../cuibt/factor_state.dart';

class Factor extends StatefulWidget {
  const Factor({super.key});

  @override
  State<Factor> createState() => _FactorState();
}

class _FactorState extends State<Factor> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ImplementCubit>().listenToImplementOrders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(dynamic date) {
    try {
      if (date == null) return '';
      DateTime dt;
      if (date is Timestamp) {
        dt = date.toDate();
      } else if (date is String) {
        dt = DateTime.tryParse(date) ?? DateTime.now();
      } else if (date is DateTime) {
        dt = date;
      } else {
        return date.toString();
      }
      return DateFormat('yyyy-MM-dd – HH:mm').format(dt);
    } catch (_) {
      return date.toString();
    }
  }

  void openImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 5,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300.h,
                  alignment: Alignment.center,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 60),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWideScreen = width > 400;

    return Scaffold(
      backgroundColor: Color(0xff0B2B40),
      appBar: AppBar(
        toolbarHeight: isWideScreen ? 140.h : 120.h,
        backgroundColor: MyColorsApp.AppBarColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white, size: 25),
          onPressed: () => _logout(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MyColorsApp.iconColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(isWideScreen ? 10.r : 8.r),
                      child: Icon(
                        Icons.factory,
                        color: Colors.white,
                        size: isWideScreen ? 20.sp : 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "مصنع الفردوس لتشغيل المعادن",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isWideScreen ? 20.sp : 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  "نظام إدارة الإنتاج والطلبات",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isWideScreen ? 20.sp : 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ImplementCubit, ImplementState>(
        builder: (context, state) {
          if (state is ImplementLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ImplementLoaded) {
            if (state.orders.isEmpty) {
              return const Center(
                child: Text(
                  "لا توجد أوردرات للتنفيذ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              );
            }

            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(isWideScreen ? 24.w : 16.w),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> order = Map<String, dynamic>.from(
                    state.orders[index].map((key, value) {
                      if (value is Map) {
                        return MapEntry(key, Map<String, dynamic>.from(value));
                      }
                      return MapEntry(key, value);
                    }),
                  );

                  final eng =
                      (order['eng review price'] as Map<String, dynamic>?) ??
                      {};
                  final images = eng['images'] as List? ?? [];

                  return Card(
                    margin: EdgeInsets.only(bottom: isWideScreen ? 24.h : 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Color(0xff1D546D),
                    child: Padding(
                      padding: EdgeInsets.all(isWideScreen ? 20.sp : 16.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "اسم العميل: ${order['name'] ?? ''}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isWideScreen ? 22.sp : 18.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "تاريخ الأوردر: ${formatDate(order['orderDate'])}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isWideScreen ? 20.sp : 18.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          if (images.isNotEmpty)
                            GestureDetector(
                              onTap: () => openImage(context, images.first),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  images.first,
                                  height: isWideScreen ? 250.h : 180.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: isWideScreen ? 250.h : 180.h,
                                      alignment: Alignment.center,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.broken_image,
                                        size: 60,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          SizedBox(height: 12.h),
                          Text(
                            "ملاحظة المهندس: ${eng['note'] ?? 'لا توجد ملاحظات'}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isWideScreen ? 18.sp : 15.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed:
                                      order['status'] == 'waiting_execution'
                                      ? () async {
                                          await context
                                              .read<ImplementCubit>()
                                              .updateStatusByOrderId(
                                                orderId: order['orderId'],
                                                newStatus: 'in_progress',
                                              );

                                          if (!mounted) return;

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                '✅ تم تحويل الأوردر إلى قيد التشغيل',
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      : null,

                                  child: const Text(
                                    "قيد التشغيل",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        (order['status'] ==
                                                'waiting_execution' ||
                                            order['status'] == 'in_progress')
                                        ? Colors.blue
                                        : Colors.blue.withAlpha(
                                            (0.5 * 255).toInt(),
                                          ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed:
                                      (order['status'] == 'waiting_execution' ||
                                          order['status'] == 'in_progress')
                                      ? () async {
                                          await context
                                              .read<ImplementCubit>()
                                              .updateStatusByOrderId(
                                                orderId: order['orderId'],
                                                newStatus: 'completed',
                                              );
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).removeCurrentSnackBar();

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                '🎉 تم تنفيذ الأوردر بنجاح',
                                              ),

                                              backgroundColor: Colors.blue,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: const Text(
                                    "تم التنفيذ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (state is ImplementError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  if (!context.mounted) return;
  Navigator.pushNamedAndRemoveUntil(
    context,
    Routes.loginScreen,
    (route) => false,
  );
}
