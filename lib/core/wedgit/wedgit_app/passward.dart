import 'package:app_alfardos/core/wedgit/wedgit_app/coloers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Password extends StatefulWidget {
  const Password({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  bool x = true;

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.r),
      borderSide: BorderSide(color: MyColorsApp.fontColor, width: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      controller: widget.controller,
      obscureText: x,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Password is required';
        if (v.length < 6) return 'Password must be at least 6 chars';
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              x = !x;
            });
          },
          child: Icon(
            x ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
        ),
        labelText: "Password",
        hintText: "12345Mgg",
        fillColor: const Color(0xff00000033),
        filled: true,
        hintStyle: TextStyle(color: MyColorsApp.fontColor, fontSize: 18.sp),

        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(),
        errorBorder: _border(),
        focusedErrorBorder: _border(),
      ),
    );
  }
}
