import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

import '../../../../../core/wedgit/Widgit_admin/costum_contaner.dart';
import '../../../../../core/wedgit/wedgit_app/coloers.dart';
import '../../../../../core/wedgit/widget_client/client_order_requst.dart';
import '../../../../../core/wedgit/widget_client/custom_client_app_bar.dart';
import '../../../client_order/data/model/order_model.dart';
import '../../../client_order/perthon/cubit/order_cubit.dart';
import '../../../client_order/perthon/cubit/order_state.dart';

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
      orderCubit = context.read<OrderCubit>();
      final userId = FirebaseAuth.instance.currentUser!.uid;
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
          appBar: CustomClientAppBar(),
          backgroundColor: MyColorsApp.mainColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.w),
                      color: MyColorsApp.AppBarColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.all(10.sp),
                    width: double.infinity,
                    child: Text(
                      "رصيدك : 1500 ",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  CostumContainer(
                    setColor: Colors.lightBlue,
                    Titel: 'اجمالي الطلبات',
                    TitelWeIcons: CupertinoIcons.cube_box,
                    intText: orders.length.toString(),
                    moText: "",
                  ),

                  SizedBox(height: 15.h),

                  CostumContainer(
                    setColor: Colors.teal,
                    Titel: 'طلبات تحت المراجعه',
                    TitelWeIcons: CupertinoIcons.shopping_cart,
                    intText:"",
                    moText: '',
                  ),

                  SizedBox(height: 15.h),

                  CostumContainer(
                    setColor: Colors.deepPurpleAccent,
                    Titel: 'طلبات مكتمله',
                    TitelWeIcons: CupertinoIcons.cube_box,
                    intText:"",
                    moText: '',
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
                      children: orders.take(5).map((order) {
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
