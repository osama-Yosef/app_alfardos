import 'package:flutter/cupertino.dart';
import 'package:app_alfardos/core/wedgit/wedgit_app/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'clint_item.dart';

class AddClient extends StatefulWidget {
  final Function(ClintItem) onAddClient;
  const AddClient({super.key, required this.onAddClient});

  @override
  State<AddClient> createState() => _AddClientState();
}

  final nameController = TextEditingController();
  final numberController = TextEditingController();

  class _AddClientState extends State<AddClient> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 400.w,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "إضافة عميل جديد",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 35.h),

              Column(
                children: [
                  CustomTextForm(
                    hintText: "اسم العميل",
                    lapText: "الاسم",
                    controller: nameController,
                    validator: (a) {},
                      keyboardType:TextInputType.text,
                  ),
                  SizedBox(height: 15.w),
                  CustomTextForm(
                    hintText: "01096525584",
                    lapText: "رقم الهاتف",
                    controller: numberController,
                    validator: (a) {},
                    keyboardType:TextInputType.text,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    final newClintItem = ClintItem(
                      name: nameController.text,
                      number: double.tryParse(numberController.text) ?? 0 ,

                    );
                    widget.onAddClient(newClintItem);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'إضافة الطلب',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
