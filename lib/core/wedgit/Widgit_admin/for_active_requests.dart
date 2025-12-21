import 'package:app_alfardos/core/wedgit/wedgit_app/coloers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'order_item.dart';

class ForActiveRequests extends StatefulWidget {
  const ForActiveRequests({super.key});

  @override
  State<ForActiveRequests> createState() => _ForActiveRequestsState();
}

class _ForActiveRequestsState extends State<ForActiveRequests> {
  List<OrderItem> orders = [];
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white12, width: 2.w),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.add_chart, color: Colors.white, size: 24.sp),
              ),
              SizedBox(width: 10.w),
              Text(
                "لطلبات النشطة",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w200,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Contaner2(
            Title: "شركة الحديد المتقدم",
            Matrial: 'أنابيب فولاذية',
            TimeDate: "موعد التسليم: 2025-01-20",
          ),
          SizedBox(height: 15.h,),
          Contaner2(
            Title: "مؤسسة المعادن الحديثة",
            Matrial: 'ألواح ألمنيوم',
            TimeDate: "موعد التسليم: 2025-01-25",
          ),
          SizedBox(height: 15.h,),
          Contaner2(
            Title: "صناعات النحاس",
            Matrial: 'قطع نحاسية مخصصة',
            TimeDate: "موعد التسليم: 2025-01-29",
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
  });

  final String Title;
  final String Matrial;
  final String TimeDate;

  @override
  Widget build(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              Title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            Matrial,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            TimeDate,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
            ),
          ),
          SizedBox(height: 8.h),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 8.w),
                  Text('التقدم', style: TextStyle(color: Colors.white)),

                  SizedBox(width: 8.w),
                  Text('45%', style: TextStyle(color: Colors.white)),
                ],
              ),
              LinearProgressIndicator(
                value: 0.45.sp,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                minHeight: 6.h,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
