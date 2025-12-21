import 'package:app_alfardos/core/wedgit/wedgit_app/bottom.dart';
import 'package:app_alfardos/core/wedgit/wedgit_app/coloers.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/wedgit/Widgit_admin/material_item.dart';
import '../../../../../core/wedgit/Widgit_admin/select_matrial.dart';

class LiveProductionFollowUp extends StatefulWidget {
  const LiveProductionFollowUp({super.key});

  @override
  State<LiveProductionFollowUp> createState() => _LiveProductionFollowUpState();
}

class _LiveProductionFollowUpState extends State<LiveProductionFollowUp> {
  List<MaterialItem> materials = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "إدارة المخزون",
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Bottom(titel: "إضافة مادة", onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.black.withAlpha(10),
                      builder: (BuildContext context) {
                        return SelectMatrial(
                          onAdd: (item) {
                            setState(() {
                              materials.add(item);
                            });
                          },
                        );
                      },
                    );
                  },),
                ],
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 35.h,
                width: 250.w,
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
                          "..بحث عن المواد..",
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

              Container(
                width: double.infinity,
                height: 550.h,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: MyColorsApp.fontColor),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            _buildHeaderCell("اسم المادة"),
                            _buildHeaderCell("الفئة"),
                            _buildHeaderCell("الوحدة"),
                            _buildHeaderCell("الحد الأعلى"),
                            _buildHeaderCell("الحد الأدنى"),
                            _buildHeaderCell("السعر"),
                            _buildHeaderCell("اسم المورد"),
                            _buildHeaderCell("تحكم"),
                          ],
                        ),
                      ),
                      ...materials.map(
                            (m) => Row(
                          children: [
                            _buildDataCell(m.name),
                            _buildDataCell(m.category),
                            _buildDataCell(m.unit),
                            _buildDataCell(m.maxLimit.toString()),
                            _buildDataCell(m.minLimit.toString()),
                            _buildDataCell("${m.price.toStringAsFixed(2)} جنيه"),
                            _buildDataCell(m.supplier),
                            _buildActionCell(() {
                              setState(() {
                                materials.remove(m);
                              });
                            }),
                          ],
                        ),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }


  Widget _buildHeaderCell(String title) {
    return Container(
      width: 120.w,
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }


  Widget _buildDataCell(String data) {
    return Container(
      width: 120.w,
      padding: EdgeInsets.all(8),
      child: Text(
        data,
        style: TextStyle(fontSize: 17.sp, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
  }


  Widget _buildActionCell(VoidCallback onDelete) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(8),
      child: IconButton(
        icon: Icon(Icons.delete, color: Colors.redAccent),
        onPressed: onDelete,
      ),
    );
  }
}
