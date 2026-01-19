// ===================== select_material_dialog.dart =====================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../admin/factuors/live_production_follow_up/data/model/material_entity _model.dart';
import '../../../admin/factuors/live_production_follow_up/perthon/cubit/material_cubit.dart';

class SelectMaterialDialog extends StatefulWidget {
  const SelectMaterialDialog({super.key});

  @override
  State<SelectMaterialDialog> createState() => _SelectMaterialDialogState();
}

class _SelectMaterialDialogState extends State<SelectMaterialDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final supplierController = TextEditingController();
  final priceController = TextEditingController();
  final minController = TextEditingController();
  final maxController = TextEditingController();

  String? category;
  String? unit;

  @override
  void dispose() {
    nameController.dispose();
    supplierController.dispose();
    priceController.dispose();
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "إضافة مادة",
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                _textField("اسم المادة", nameController),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _dropdown("الفئة", ["حديد", "استلس", "ألمنيوم"], (v) => category = v),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _dropdown("الوحدة", ["كجم", "طن", "لوح"], (v) => unit = v),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                _textField("الحد الأدنى", minController, isNumber: true),
                SizedBox(height: 10.h),
                _textField("الحد الأعلى", maxController, isNumber: true),
                SizedBox(height: 10.h),
                _textField("السعر", priceController, isNumber: true),
                SizedBox(height: 10.h),
                _textField("اسم المورد", supplierController),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text("إضافة"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final material = MaterialEntity(
      id: '',
      name: nameController.text,
      category: category ?? "",
      unit: unit ?? "",
      price: double.parse(priceController.text),
      supplier: supplierController.text,
      minLimit: double.parse(minController.text),
      maxLimit: double.parse(maxController.text),
    );

    context.read<MaterialCubit>().addMaterial(material);
    Navigator.pop(context);
  }

  Widget _textField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (v) => v!.isEmpty ? "مطلوب" : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      validator: (v) => v == null ? "مطلوب" : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
