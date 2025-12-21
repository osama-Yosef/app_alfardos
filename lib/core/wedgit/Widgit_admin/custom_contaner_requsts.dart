import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../wedgit_app/coloers.dart';

class CustomContanerRequsts extends StatelessWidget {
  const CustomContanerRequsts({
    super.key,
    required this.name,
    required this.number,
    required this.token,
    required this.theRest,
    required this.product,
    required this.material,
    required this.priority,
    required this.amount,
    required this.size,
    required this.comment,
    required this.TextStat,
    this.onDelete,
    this.onVio,
  });

  final String name;
  final double number;
  final double token;
  final double theRest;
  final String product;
  final String material;
  final String priority;
  final double amount;
  final double size;
  final String comment;
  final String TextStat;
  final VoidCallback? onDelete;
  final VoidCallback? onVio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border.all(color: Colors.white30, width: 2.w),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 99),
            decoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(color: Colors.black26, width: 2.w),
              borderRadius: BorderRadius.circular(45.r),
            ),
            child: Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 15.sp),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.white30, width: 2.w),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Text(
              TextStat,
              style: TextStyle(color: Colors.white, fontSize: 15.sp),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            TextStat,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "رقم الهاتف: $number",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "العربون: $token",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "المتبقي: $theRest",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),

          Text(
            "الأولوية: $priority",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),

          Text(
            "المنتج: $product",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "المادة: $material",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "الكمية: $amount",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            "المقاس",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            "${size}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Color(0xFF2E323B), width: 2.w),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            "ملاحظات",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            comment,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: MyColorsApp.iconColor,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: MyColorsApp.iconColor,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.download_outlined,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: InkWell(
                  onTap: onDelete,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: MyColorsApp.iconColor,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.delete, color: Colors.red, size: 18.sp),
                  ),
                ),
              ),
              SizedBox(width: 30.w),
            ],
          ),
        ],
      ),
    );
  }
}
