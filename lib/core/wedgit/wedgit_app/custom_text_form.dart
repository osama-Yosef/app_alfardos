import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'coloers.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    required this.hintText,
    required this.lapText,
    this.validator,
    this.controller,
    this.keyboardType,
  });

  final String hintText;
  final String lapText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        onTapOutside: (o) => FocusScope.of(context).unfocus(),
        validator: validator,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,

        decoration: InputDecoration(
          label: Text(
            lapText,
            style: TextStyle(color: Colors.black, fontSize: 20.sp),
          ),
          hintText: hintText,
          fillColor: const Color(0xff00000033),
          filled: true,
          hintStyle: TextStyle(color: MyColorsApp.fontColor, fontSize: 15.sp),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: MyColorsApp.fontColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: MyColorsApp.fontColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: MyColorsApp.fontColor),
          ),
        ),
      ),
    );
  }
}
