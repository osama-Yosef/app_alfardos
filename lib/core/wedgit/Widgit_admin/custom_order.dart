
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../wedgit_app/custom_text_form.dart';

class CustomOrder extends StatelessWidget {
  const CustomOrder({super.key, required this.hintText, required this.lapText, required this.validator});
final String hintText;
  final String lapText;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return   Container(
      width: 400.w,
      decoration: BoxDecoration(
          color:Colors.white.withAlpha(80),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.black,width: 1.5.w)
      ),
      child: CustomTextForm(hintText:hintText , lapText: lapText, validator:validator ),
    );
  }
}
