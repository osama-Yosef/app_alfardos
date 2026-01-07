import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/wedgit/wedgit_app/coloers.dart';
import '../cuibt/factor_cubit.dart';
import '../cuibt/factor_state.dart';

// ================= FACTOR PAGE مع BlocProvider جاهز =================
class FactorPage extends StatelessWidget {
  const FactorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImplementCubit(FirebaseFirestore.instance)..listenToImplementOrders(),
      child: const Factor(),
    );
  }
}

// ================= FACTOR WIDGET =================
class Factor extends StatelessWidget {
  const Factor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120.h,
        backgroundColor: MyColorsApp.AppBarColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => _logout(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
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
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.factory,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "مصنع الفردوس لتشغيل المعادن",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
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
                    fontSize: 14.sp,
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
              return const Center(child: Text("لا توجد أوردرات للتنفيذ"));
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                final eng = order['eng review price'];

                return Card(
                  margin: EdgeInsets.only(bottom: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "اسم العميل: ${order['name']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text("تاريخ الأوردر: ${order['orderDate']}"),
                        SizedBox(height: 10.h),
                        if ((eng['images'] as List).isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              eng['images'][0],
                              height: 180.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        SizedBox(height: 10.h),
                        Text(
                          "ملاحظة المهندس: ${eng['note']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  context
                                      .read<ImplementCubit>()
                                      .updateStatus(order['id'], 'in_progress');
                                },
                                child: const Text("قيد التشغيل"),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  context
                                      .read<ImplementCubit>()
                                      .updateStatus(order['id'], 'completed');
                                },
                                child: const Text("تم التنفيذ"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
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

// ================= LOGOUT =================
void _logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushNamedAndRemoveUntil(
    context,
    Routes.loginScreen,
        (route) => false,
  );
}
