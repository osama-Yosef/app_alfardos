import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../admin/factuors/eng_screen/perthon/cubit/eng_cubit.dart';
import '../../../../../core/wedgit/Widgit_admin/costum_contaner.dart';
import '../../../../../core/wedgit/wedgit_app/coloers.dart';
import '../../../../../core/wedgit/widget_client/client_order_requst.dart';
import '../../../../../core/wedgit/widget_client/custom_client_app_bar.dart';
import '../../../client_order/data/model/order_model.dart';
import '../../../client_order/perthon/cubit/order_cubit.dart';
import '../../../client_order/perthon/cubit/order_state.dart';
import '../cuibt/client_balance_cubit.dart';
import '../cuibt/client_balance_state.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  late OrderCubit orderCubit;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      context.read<ClientBalanceCubit>().loadClientBalance(userId);
      context.read<ClientBalanceCubit>().loadClientOrdersCount(userId);

      orderCubit = context.read<OrderCubit>();
      orderCubit.listenToOrders(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        List<OrderModel> orders = [];

        if (state is GetOrdersSuccess) {
          orders = state.orders;
        }

        return Scaffold(
          appBar: const CustomClientAppBar(),
          backgroundColor: MyColorsApp.mainColor,
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.h),

                        CostumContainer(
                          setColor: Colors.lightBlue,
                          Titel: 'اجمالي الطلبات',
                          TitelWeIcons: CupertinoIcons.cube_box,
                          intText: orders.length.toString(),
                          moText: "",
                        ),

                        SizedBox(height: 15.h),

                        BlocBuilder<ClientBalanceCubit, ClientBalanceState>(
                          builder: (context, state) {
                            int count = 0;

                            if (state is ClientOrdersCountSuccess) {
                              count = state.inProgressCount;
                            }

                            return CostumContainer(
                              setColor: Colors.teal,
                              Titel: 'طلبات قيد التشغيل',
                              TitelWeIcons: CupertinoIcons.shopping_cart,
                              intText: count.toString(),
                              moText: '',
                            );
                          },
                        ),


                        SizedBox(height: 15.h),

                        BlocBuilder<ClientBalanceCubit, ClientBalanceState>(
                          builder: (context, state) {
                            int count = 0;

                            if (state is ClientOrdersCountSuccess) {
                              count = state.completedCount;
                            }

                            return CostumContainer(
                              setColor: Colors.deepPurpleAccent,
                              Titel: 'طلبات مكتمله',
                              TitelWeIcons: CupertinoIcons.cube_box,
                              intText: count.toString(),
                              moText: '',
                            );
                          },
                        ),


                        SizedBox(height: 20.h),

                        Text(
                          "الطلبات الاخيره",
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),

                        SizedBox(height: 15.h),

                        if (state is OrderLoading && orders.isEmpty)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(30.h),
                              child: const CircularProgressIndicator(),
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
                            children: orders.take(5).map((order) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15.h),
                                child: ClientOrderRequst(
                                  order: order,
                                  isEngineer: true,
                                  onDelete: () {
                                    context
                                        .read<EngOrderCubit>()
                                        .deleteOrder(order.id);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
