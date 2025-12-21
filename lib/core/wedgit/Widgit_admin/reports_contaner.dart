import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportsContaner extends StatelessWidget {
  const ReportsContaner ({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),

      width: double.infinity,
      height: 220.h,

      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(color: Colors.white12, width: 2.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
              Text("إنتاج هذا الأسبوع",style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              ),
            SizedBox(height: 20.h),
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("الفولاذ",style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w200,
                    color: Colors.white70,
                  ),
              
                  ),
                  Text("2.5 طن",style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                  )
              
                ],
              ),
            ),
            SizedBox(height: 10.h,),
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("الألمنيوم",style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w200,
                    color: Colors.white70,
                  ),
              
                  ),
                  Text("1.8 طن",style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                  )
              
                ],
              ),
            ),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("النحاس",style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w200,
                  color: Colors.white70,
                ),
        
                ),
                Text("0.7 طن",style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
                )
        
              ],
            ),
            SizedBox(height: 10.h),
        
          ],
        ),
      ),

    );
  }
}
