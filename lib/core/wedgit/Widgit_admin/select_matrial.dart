import 'package:app_alfardos/core/wedgit/wedgit_app/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'material_item.dart';

class SelectMatrial extends StatefulWidget {
  final Function(MaterialItem) onAdd;

  const SelectMatrial({super.key, required this.onAdd}); // ✅ تم التصحيح

  @override
  State<SelectMatrial> createState() => _SelectMatrialState();
}

class _SelectMatrialState extends State<SelectMatrial> {
  final nameController = TextEditingController();
  final supplierController = TextEditingController();
  final priceController = TextEditingController();
  final minController = TextEditingController();
  final maxController = TextEditingController();

  String? selectedCategory;
  String? selectedUnit;

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
                "إضافة مادة جديدة",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),

              /// اسم المادة
              CustomTextForm(
                hintText: "اسم المادة",
                lapText: "اسم المادة",
                controller: nameController,
                validator: (a) {},
              ),

              SizedBox(height: 15.h),

              /// Dropdowns
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedUnit,
                      items: const [
                        DropdownMenuItem(value: 'لوح', child: Text('لوح')),
                        DropdownMenuItem(value: 'كجم', child: Text('كجم')),
                        DropdownMenuItem(value: 'طن', child: Text('طن')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'الوحدة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => selectedUnit = val);
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: const [
                        DropdownMenuItem(value: 'حديد', child: Text('حديد')),
                        DropdownMenuItem(value: 'استلس', child: Text('استلس')),
                        DropdownMenuItem(value: 'المونيوم', child: Text('المونيوم')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'الفئة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => selectedCategory = val);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              /// الحدود
              Row(
                children: [
                  Expanded(
                    child: CustomTextForm(
                      hintText: 'الحد الأعلى',
                      lapText: 'الحد الأعلى',
                      controller: maxController,
                      validator: (a) {},
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomTextForm(
                      hintText: 'الحد الأدنى',
                      lapText: 'الحد الأدنى',
                      controller: minController,
                      validator: (a) {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              /// السعر والمورد
              CustomTextForm(
                hintText: "سعر القطعة",
                lapText: "السعر",
                controller: priceController,
                validator: (a) {},
              ),
              SizedBox(height: 15.h),
              CustomTextForm(
                controller: supplierController,
                hintText: "اسم المورد",
                lapText: "اسم المورد",
                validator: (a) {},
              ),

              SizedBox(height: 20.h),

              /// زر الإضافة
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
                    final newMaterial = MaterialItem(
                      name: nameController.text,
                      category: selectedCategory ?? '',
                      unit: selectedUnit ?? '',
                      price: double.tryParse(priceController.text) ?? 0,
                      supplier: supplierController.text,
                      minLimit: double.tryParse(minController.text) ?? 0,
                      maxLimit: double.tryParse(maxController.text) ?? 0,
                    );
                    widget.onAdd(newMaterial);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'إضافة المادة',
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
