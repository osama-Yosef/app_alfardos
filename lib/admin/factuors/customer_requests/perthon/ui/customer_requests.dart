import 'package:app_alfardos/core/wedgit/wedgit_app/bottom.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../client/factuors/client_order/data/model/order_model.dart';
import '../../../../../client/factuors/client_order/perthon/cubit/order_cubit.dart';
import '../../../../../client/factuors/client_order/perthon/cubit/order_state.dart';
import '../../../../../core/wedgit/Widgit_admin/show_orders.dart';
import '../../../../../core/wedgit/wedgit_app/coloers.dart';
import '../../../../../core/wedgit/widget_client/client_select_order.dart';
import '../../../eng_screen/perthon/cubit/eng_cubit.dart';
import '../../../eng_screen/perthon/cubit/eng_state.dart';

class CustomerRequests extends StatefulWidget {
  const CustomerRequests({super.key});

  @override
  State<CustomerRequests> createState() => _CustomerRequestsState();
}

class _CustomerRequestsState extends State<CustomerRequests> {
  late OrderCubit orderCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      orderCubit = context.read<OrderCubit>();
      context.read<EngOrderCubit>().listenToAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم إرسال الطلب بنجاح")),
          );
        } else if (state is OrderError) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("خطأ: ${state.message}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColorsApp.mainColor,
          appBar: CustomAppBar(),

          body: LayoutBuilder(
            builder: (context, constraints) {
              final bool isDesktop = constraints.maxWidth > 900;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1000 : double.infinity,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 30.w : 16.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "إدارة طلبات العملاء",
                            style: TextStyle(
                              fontSize: isDesktop ? 26.sp : 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Center(
                          child: Text(
                            "إدارة ومتابعة جميع طلبات العملاء",
                            style: TextStyle(
                              fontSize: isDesktop ? 18.sp : 16.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: isDesktop ? 220.w : double.infinity,
                            child: Bottom(
                              titel: "طلب جديد",
                              onTap: () => _openNewOrderDialog(context),
                            ),
                          ),
                        ),

                        SizedBox(height: 25.h),


                        Expanded(child: _ordersList()),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _openNewOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withAlpha(80),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 50.h,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClientSelectOrder(
                OnAdd: (newOrder) async {
                  final orderModel = OrderModel(
                    name: newOrder.name,
                    numper: newOrder.numper.toInt(),
                    prodact: newOrder.product,
                    matrial: newOrder.material,
                    quantity: newOrder.amount.toInt(),
                    size: newOrder.size.toString(),
                    desc: newOrder.comment,
                    images: [],
                    files: [],
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    createdAt: DateTime.now(),
                  );

                  await orderCubit.createOrder(
                    orderModel,
                    newOrder.imageFiles ?? [],
                    newOrder.fileFiles ?? [],
                  );

                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}


Widget _ordersList() {
  return BlocListener<EngOrderCubit, EngOrderState>(
    listener: (context, state) {
      if (state is EngOrderFileUploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${state.type} تم رفعه بنجاح")),
        );
      } else if (state is EngOrderError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ: ${state.message}")),
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
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final order = orders[index];

              return ShowOrders(
                order: order,
                isEngineer: true,
                onDelete: () {
                  context.read<EngOrderCubit>().deleteOrder(order.id);
                },
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

        return const SizedBox();
      },
    ),
  );
}
