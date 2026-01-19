import 'package:app_alfardos/core/wedgit/wedgit_app/coloers.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/custom_app_bar.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/costum_contaner.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/for_active_requests.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/hello_contaner.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/reports_contaner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeCubit>().listenActiveOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColorsApp.mainColor,
      appBar: const CustomAppBar(),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 900;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40.w : 12.w,
                vertical: 16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 1350 : double.infinity,
                    ),
                    child: Column(
                      children: [
                        HelloContaner(),
                        SizedBox(height: 20.h),
                        _activeOrdersCard(),
                        SizedBox(height: 20.h),
                        ForActiveRequests(),

                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ReportsContaner(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _activeOrdersCard() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        int count = 0;

        if (state is HomeOrdersLoaded) {
          count = state.inProgressCount;
        }

        return CostumContainer(
          setColor: MyColorsApp.Bleudark.withValues(alpha: 0.8),
          Titel: 'الطلبات النشطة',
          TitelWeIcons: Icons.add_chart,
          intText: '$count',
          moText: '+12% من الأسبوع الماضي',
        );
      },
    );
  }
}
