import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/wedgit/Widgit_admin/eng_app_par.dart';
import '../../../../../core/wedgit/Widgit_admin/eng_screen_order.dart';
import '../cubit/eng_cubit.dart';
import '../cubit/eng_state.dart';

class EngScreen extends StatefulWidget {
  const EngScreen({super.key});

  @override
  State<EngScreen> createState() => _EngScreenState();
}

class _EngScreenState extends State<EngScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EngOrderCubit>().listenToAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngAppPar(),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 1100 : double.infinity,
              ),
              child: Column(
                children: [
                  SizedBox(height: isDesktop ? 20 : 10),

                  Text(
                    "الطلبات الوارده",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 26 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 24 : 12,
                        vertical: 12,
                      ),
                      child: _ordersList(isDesktop),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _ordersList(bool isDesktop) {
    return BlocListener<EngOrderCubit, EngOrderState>(
      listener: (context, state) {
        if (state is EngOrderFileUploaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${state.type} تم رفعه بنجاح"),
              duration: Duration(seconds: 3),
            ),
          );
        } else if (state is EngOrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("حدث خطأ: ${state.message}"),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<EngOrderCubit, EngOrderState>(
        builder: (context, state) {
          if (state is EngOrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EngOrderLoaded) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return const Center(child: Text("لا يوجد طلبات"));
            }

            return ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => SizedBox(height: 15.h),
              itemBuilder: (context, index) {
                final order = orders[index];

                return Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: EngScreenOrder(
                    order: order,
                    isEngineer: true,
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("تأكيد الحذف"),
                          content: const Text("هل تريد حذف الطلب؟"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("لا"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("نعم"),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        context.read<EngOrderCubit>().deleteOrder(order.id);
                      }
                    },
                  ),
                );
              },
            );
          }

          if (state is EngOrderError) {
            return Center(
              child: Text(
                "حدث خطأ: ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(child: Text("جارٍ تحميل البيانات..."));
        },
      ),
    );
  }
}
