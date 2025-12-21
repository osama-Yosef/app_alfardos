

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key, required this.titel, required this.onTap});
final String titel ;
final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap:onTap ,

      child: Container(
        width: 140.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.white12, width: 2.w),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white, size: 25.sp),
              Text(
                titel ,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
