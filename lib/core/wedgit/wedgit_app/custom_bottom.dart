import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'coloers.dart';

class CustomBottom extends StatelessWidget {
  const CustomBottom({super.key, required this.titel, required this.onTap});

  final String titel;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 145.h, vertical: 20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: MyColorsApp.iconColor,
        ),
        child: Text(
          titel,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
