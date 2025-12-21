
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelloContaner extends StatelessWidget {
  const HelloContaner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity.w,
        height: 220.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(
            image: AssetImage("asset/image/mainPhoto.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              Text(
                "مصنع الفردوس لتشغيل المعادن يرحب بكم",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 4.r,
                    ),
                  ],
                ),
              ),
              Text(
                "متابعة شاملة للإنتاج وطلبات العملاء بدقة عاليه ",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 4.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
