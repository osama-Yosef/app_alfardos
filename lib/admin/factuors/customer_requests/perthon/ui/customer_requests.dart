import 'package:app_alfardos/core/wedgit/wedgit_app/bottom.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/custom_app_bar.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/order_item.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/custom_contaner_requsts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/wedgit/wedgit_app/coloers.dart';
import '../../../../../core/wedgit/Widgit_admin/select_order.dart';

class CustomerRequests extends StatefulWidget {
  const CustomerRequests({super.key});

  @override
  State<CustomerRequests> createState() => _CustomerRequestsState();
}


class _CustomerRequestsState extends State<CustomerRequests> {
  String selectedStatus = 'جميع الحالات';
  List<OrderItem> orders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColorsApp.mainColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "إدارة طلبات العملاء",
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "إدارة ومتابعة جميع طلبات العملاء",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20.h),
              Bottom(titel: "طلب جديد", onTap:  () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierColor: Colors.black.withAlpha(80),
                  builder: (BuildContext dialogContext) {
                    return SelectOrder(
                      OnAdd: (item) {
                        setState(() {
                          orders.add(item);
                        });
                        Navigator.pop(dialogContext);
                      },
                    );
                  },
                );
              },),
              SizedBox(height: 15.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Colors.black38, width: 2.w),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                      width: double.infinity,
                      child: TextFormField(
                          onTapOutside: (o) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            hint: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "..بحث عن العميل, المنتج, طلب",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                 Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),

                              ],
                            ) ,
                          ),
                        ),
                ),
                    SizedBox(height: 10.h),

                  ],
                ),
              ),
              SizedBox(height: 20.h),

              if (orders.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(30.h),
                    child: Text(
                      "لا توجد طلبات حالياً",
                      style: TextStyle(color: Colors.white70, fontSize: 18.sp),
                    ),
                  ),
                )
              else
                Column(
                  children: orders.asMap().entries.map((entry) {
                    final index = entry.key;
                    final order = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: CustomContanerRequsts(
                        name: order.name,
                        number: order.number,
                        token: order.token,
                        theRest: order.theRest,
                        product: order.product,
                        material: order.material,
                        priority: order.priority,
                        amount: order.amount,
                        size: order.size,
                        comment: order.comment,
                        TextStat: "قيد التنفيذ",
                        onDelete: () {
                          setState(() {
                            orders.removeAt(index);
                          });
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
  }
}
