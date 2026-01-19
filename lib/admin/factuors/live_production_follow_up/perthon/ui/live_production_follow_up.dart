import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_alfardos/core/wedgit/Widgit_admin/custom_app_bar.dart';

import '../../../../../core/wedgit/Widgit_admin/select_matrial.dart';
import '../../data/model/material_entity _model.dart';
import '../cubit/material_cubit.dart';
import '../cubit/material_state.dart';

class LiveProductionFollowUp extends StatelessWidget {
  const LiveProductionFollowUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: BlocBuilder<MaterialCubit, MaterialState>(
          builder: (context, state) {
            if (state is MaterialLoading) return const Center(child: CircularProgressIndicator());
            if (state is MaterialError) return Center(child: Text("حدث خطأ: ${state.message}"));
            if (state is MaterialLoaded) {
              if (state.materials.isEmpty) return _emptyState();
              return _materialTable(context, state.materials);
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const SelectMaterialDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80.sp, color: Colors.grey),
          SizedBox(height: 10.h),
          Text("لا توجد مواد في المخزون", style: TextStyle(fontSize: 18.sp, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _materialTable(BuildContext context, List<MaterialEntity> materials) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
          columns: const [
            DataColumn(label: Text("اسم المادة")),
            DataColumn(label: Text("الفئة")),
            DataColumn(label: Text("الوحدة")),
            DataColumn(label: Text("الحد الأدنى")),
            DataColumn(label: Text("الحد الأعلى")),
            DataColumn(label: Text("السعر")),
            DataColumn(label: Text("المورد")),
            DataColumn(label: Text("تحكم")),
          ],
          rows: materials.map((m) {
            return DataRow(
              cells: [
                DataCell(Text(m.name)),
                DataCell(Text(m.category)),
                DataCell(Text(m.unit)),
                DataCell(Text(m.minLimit.toString())),
                DataCell(Text(m.maxLimit.toString())),
                DataCell(Text("${m.price} جنيه")),
                DataCell(Text(m.supplier)),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<MaterialCubit>().deleteMaterial(m.id);
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
