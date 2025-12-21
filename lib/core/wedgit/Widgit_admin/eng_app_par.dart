import 'package:app_alfardos/core/wedgit/wedgit_app/coloers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../routing/routes.dart';

class EngAppPar extends StatelessWidget implements PreferredSizeWidget {
  const EngAppPar ({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),

      ],
      leading:IconButton(
        icon: const Icon(Icons.logout,color: Colors.white,),
        onPressed: () => _logout(context),
      ),
      automaticallyImplyLeading: false,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: MyColorsApp.iconColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.factory, color: Colors.white, size: 24.sp),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Center(
                      child: Text(
                        "مصنع الفردوس لتشغيل المعادن",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    "نظام إدارة الإنتاج والطلبات",
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
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
                        onTap: (){
                          Navigator.pushNamed(context, Routes.EngScreen);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Color(0xFF2E323B), width: 2.w),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.home_filled, color: Colors.white, size: 18.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, Routes.AdminChatsPage );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: MyColorsApp.iconColor, width: 2.w),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.people_alt_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30.w),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
void _logout(BuildContext context) async{
  await FirebaseAuth.instance.signOut();
  Navigator.pushNamedAndRemoveUntil(
    context,
    Routes.loginScreen,
        (route) => false,
  );
}



