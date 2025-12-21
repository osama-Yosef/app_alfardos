import 'package:app_alfardos/core/wedgit/wedgit_app/coloers.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/custom_app_bar.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/costum_contaner.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/for_active_requests.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/hello_contaner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/wedgit/Widgit_admin/order_item.dart';
import '../../../../../core/wedgit/Widgit_admin/reports_contaner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<OrderItem> orders = [

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColorsApp.mainColor,
      appBar: CustomAppBar(),
      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              HelloContaner(),
              SizedBox(height: 10.h),
              CostumContainer(
                setColor: MyColorsApp.Bleudark.withValues(alpha: 0.8),
                Titel: 'الطلبات النشطه',
                TitelWeIcons: Icons.add_chart,
                intText: '${orders.length}',
                moText: '+12% من الأسبوع الماضي',
              ),

              SizedBox(height: 20.h),
              ForActiveRequests(),
              SizedBox(height: 10.h),
              ReportsContaner()
            ],
          ),
        ),
      ),
    );
  }
}
