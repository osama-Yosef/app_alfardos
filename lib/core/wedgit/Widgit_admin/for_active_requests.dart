import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../admin/factuors/home_screen/perthon/cubit/home_cubit.dart';
import 'package:app_alfardos/core/wedgit/wedgit_app/coloers.dart';

class ForActiveRequests extends StatelessWidget {
  const ForActiveRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.add_chart, color: Colors.white),
              SizedBox(width: 10.w),
              Text(
                "الطلبات النشطة",
                style: TextStyle(fontSize: 20.sp, color: Colors.white70),
              ),
            ],
          ),
          SizedBox(height: 25.h),

          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const CircularProgressIndicator();
              }

              if (state is HomeOrdersLoaded) {
                if (state.orders.isEmpty) {
                  return Text(
                    'لا توجد طلبات نشطة',
                    style: TextStyle(color: Colors.white54),
                  );
                }

                return Column(
                  children: state.orders.map((order) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Contaner2(
                        Title: order.name,
                        Matrial: order.matrial,
                        TimeDate: "موعد التسليم: ${order.deliveryDate}",
                        progress: order.progress,
                      ),
                    );
                  }).toList(),
                );
              }

              if (state is HomeError) {
                return Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class Contaner2 extends StatelessWidget {
  const Contaner2({
    super.key,
    required this.Title,
    required this.Matrial,
    required this.TimeDate,
    required this.progress,
  });

  final String Title;
  final String Matrial;
  final String TimeDate;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final int progressPercent = (progress * 100).toInt();

    return Container(
      width: double.infinity,
      height: 200.h,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: MyColorsApp.mainColor, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              Title,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            Matrial,
            style: TextStyle(
                fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white60),
          ),
          SizedBox(height: 8.h),
          Text(
            TimeDate,
            style: TextStyle(
                fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white60),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('التقدم', style: TextStyle(color: Colors.white)),
              Text('$progressPercent%', style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 6.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            minHeight: 6.h,
          ),
        ],
      ),
    );
  }
}
