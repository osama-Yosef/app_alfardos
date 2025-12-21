import 'package:app_alfardos/core/wedgit/wedgit_app/custom_text_form.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectOrder extends StatefulWidget {
  final Function(OrderItem) OnAdd;

  const SelectOrder({super.key, required this.OnAdd});

  @override
  State<SelectOrder> createState() => _SelectOrder();
}

class _SelectOrder extends State<SelectOrder> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final tokenController = TextEditingController();
  final theRestController = TextEditingController();
  final productController = TextEditingController();
  final amountController = TextEditingController();
  final sizeController = TextEditingController();
  final commentController = TextEditingController();

  String? selectedPriority;
  String? selectedMaterial;

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
                "إضافة طلب جديد",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 35.h),

              Row(
                children: [
                  Expanded(
                    child: CustomTextForm(
                      hintText: "اسم العميل",
                      lapText: "الاسم",
                      controller: nameController,
                      validator: (a) {},
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomTextForm(
                      hintText: "01096525584",
                      lapText: "رقم الهاتف",
                      controller: numberController,
                      validator: (a) {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              Row(
                children: [
                  Expanded(
                    child: CustomTextForm(
                      hintText: "وصف المنتج",
                      lapText: "المنتج",
                      controller: productController,
                      validator: (a) {},
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedMaterial,
                      items: const [
                        DropdownMenuItem(value: 'حديد', child: Text('حديد')),
                        DropdownMenuItem(value: 'استلس', child: Text('استلس')),
                        DropdownMenuItem(value: 'المنيوم', child: Text('المنيوم')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'المادة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => selectedMaterial = val);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              Row(
                children: [
                  Expanded(
                    child: CustomTextForm(
                      hintText: "العربون",
                      lapText: "العربون",
                      controller: tokenController,
                      validator: (a) {},
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomTextForm(
                      hintText: "الباقي",
                      lapText: "الباقي",
                      controller: theRestController,
                      validator: (a) {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedPriority,
                      items: const [
                        DropdownMenuItem(value: 'عالية', child: Text('عالية')),
                        DropdownMenuItem(value: 'متوسطة', child: Text('متوسطة')),
                        DropdownMenuItem(value: 'منخفضة', child: Text('منخفضة')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'الأولوية',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => selectedPriority = val);
                      },
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomTextForm(
                      hintText: "ادخل الكمية",
                      lapText: "الكمية",
                      controller: amountController,
                      validator: (a) {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              CustomTextForm(
                hintText: "الطول × العرض (السمك)",
                lapText: "المقاس",
                controller: sizeController,
                validator: (a) {},
              ),

              SizedBox(height: 15.h),

              CustomTextForm(
                hintText: "أي ملاحظات أو متطلبات",
                lapText: "ملاحظات",
                controller: commentController,
                validator: (a) {},
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
                    final newOrderItem = OrderItem(
                      name: nameController.text,
                      number: double.tryParse(numberController.text) ?? 0 ,
                      token: double.tryParse(tokenController.text) ?? 0,
                      theRest: double.tryParse(theRestController.text) ?? 0,
                      product: productController.text,
                      material: selectedMaterial ?? '',
                      priority: selectedPriority ?? '',
                      amount: double.tryParse(amountController.text) ?? 0,
                      size:double.tryParse(sizeController.text) ?? 0 ,
                      comment: commentController.text,
                    );
                    widget.OnAdd(newOrderItem);
                    Navigator.pop;
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
