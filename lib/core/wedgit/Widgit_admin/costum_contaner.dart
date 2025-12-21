import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CostumContainer extends StatelessWidget {
  const CostumContainer({
    super.key,
    required this.setColor,
    required this.Titel,
    required this.TitelWeIcons,
    required this.intText,
    required this.moText,
  });

  final Color setColor;
  final String Titel;
  final String intText;
  final String moText;
  final IconData TitelWeIcons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),

      width: double.infinity,
      height: 195.h,
      decoration: BoxDecoration(
        color: setColor,
        border: Border.all(color: Colors.white12, width: 2.w),
        borderRadius: BorderRadius.circular(8.r),
      ),

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Titel,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        
                Container(
                  decoration: BoxDecoration(
                    color: setColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.black38, width: 2.w),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(TitelWeIcons, color: Colors.white, size: 24.sp),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              intText,
              style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              moText,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
