import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_alfardos/core/wedgit/widget_client/client_select_order.dart';
import 'package:app_alfardos/core/wedgit/widget_client/custom_client_app_bar.dart';
import 'package:app_alfardos/core/wedgit/widget_client/client_order_requst.dart';
import 'package:app_alfardos/core/wedgit/wedgit_app/coloers.dart';

import '../../data/model/order_model.dart';
import '../cubit/order_cubit.dart';
import '../cubit/order_state.dart';

class ClientOrder extends StatefulWidget {
  const ClientOrder({super.key});

  @override
  State<ClientOrder> createState() => _ClientOrderState();
}

class _ClientOrderState extends State<ClientOrder> {
  late OrderCubit orderCubit;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderCubit = context.read<OrderCubit>();
      final userId = FirebaseAuth.instance.currentUser!.uid;
      orderCubit.listenToLastOrder(userId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {

        if (state is OrderSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Order sent successfully!")),
          );
        }else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        List<OrderModel> orders = [];
        if (state is GetOrdersSuccess) orders = state.orders;

        return Scaffold(
          backgroundColor: MyColorsApp.mainColor,
          appBar: CustomClientAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "لإنشاء طلب",
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "لإنشاء الطلبات ومتابعة العمل",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  ClientSelectOrder(
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
                    },
                  ),

                  SizedBox(height: 25.h),

                  if (state is OrderLoading && orders.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.h),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (orders.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.h),
                        child: Text(
                          "لا يوجد طلبات",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: orders.map((order) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: ClientOrderRequst(
                            order: order,
                            onDelete: () async {
                              await orderCubit.deleteOrder(order.id);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
