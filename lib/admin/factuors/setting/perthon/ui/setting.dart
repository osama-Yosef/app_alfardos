import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/wedgit/Widgit_admin/calculator.dart';
import '../../../../../core/wedgit/Widgit_admin/custom_app_bar.dart';
import '../../../../../core/wedgit/wedgit_app/custom_text_form.dart';
import '../../data/model/model_prise.dart';
import '../cubit/pricing_cubit.dart';
import '../cubit/pricing_state.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
    context.read<SettingCubit>().listenToOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          return Scrollbar(
            thumbVisibility: isDesktop,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1100 : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 24 : 15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: _weightCalculatorButton(
                                context,
                                isDesktop,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 80.w,
                                height: 55.h,
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  border: Border.all(
                                    width: 1.w,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.AdminChatsPage,
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 5,
                                    children: [
                                      Center(
                                        child: Text(
                                          "صفحه المهندسين",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isDesktop ? 20 : 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.engineering,
                                        size: 20.sp,
                                        color: Colors.blueAccent,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),
                        BlocBuilder<SettingCubit, SettingState>(
                          builder: (context, state) {
                            if (state is SettingLoading) {
                              return const CircularProgressIndicator();
                            }

                            if (state is SettingError) {
                              return Text("خطأ: ${state.message}");
                            }

                            if (state is SettingLoaded) {
                              if (state.orders.isEmpty) {
                                return const Text("لا توجد طلبات");
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.orders.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: isDesktop ? 20 : 15.h),
                                itemBuilder: (context, i) => _orderCard(
                                  context,
                                  state.orders[i],
                                  isDesktop,
                                ),
                              );
                            }

                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= CARD =================
  Widget _orderCard(BuildContext context, PricingModel order, bool isDesktop) {
    return Card(
      color: const Color(0xffEAE0CF),
      elevation: isDesktop ? 6 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 20 : 12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ الطلب: ${_formatDate(order.createdAt)}",
              style: TextStyle(
                fontSize: isDesktop ? 16 : 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "اسم العميل: ${order.clientName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isDesktop ? 22 : 25,
                color: const Color(0xff213448),
              ),
            ),
            Text(
              "رقم العميل: ${order.clientPhone}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isDesktop ? 18 : 20,
                color: const Color(0xff213448),
              ),
            ),
            const Divider(),
            if (order.engFiles.isNotEmpty) ...[
              const Text(
                "ملفات المهندس:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...order.engFiles.map((file) => _fileItem(context, file)),
            ],
            if (order.engImages.isNotEmpty) ...[
              SizedBox(height: 10),
              SizedBox(
                height: isDesktop ? 180 : 120.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: order.engImages.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.black,
                            child: InteractiveViewer(
                              child: Image.network(order.engImages[i]),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          order.engImages[i],
                          width: isDesktop ? 300 : 260.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 10),
            Text(
              "ملاحظة المهندس: ${order.engNote}",
              style: TextStyle(
                fontSize: isDesktop ? 16 : 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff213448),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _openPricingDialog(context, order.orderId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 24.w,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    "تسعير العميل",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: isDesktop ? 200 : null,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<SettingCubit>().confirmOrderForExecution(
                        orderId: order.orderId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      "للتنفيذ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= CALCULATOR BUTTON =================
  Widget _weightCalculatorButton(BuildContext context, bool isDesktop) {
    return SizedBox(
      width: 180.w,
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const Dialog(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: WeightCalculator(),
              ),
            ),
          );
        },
        icon: Image.asset('asset/icons/calculator.png', width: 28),
        label: const Text(
          "احسب الوزن",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white30,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ================= PRICING DIALOG =================
  void _openPricingDialog(BuildContext context, String orderId) {
    final total = TextEditingController();
    final material = TextEditingController();
    final laser = TextEditingController();
    final note = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextForm(
                    lapText: "السعر الإجمالي",
                    controller: total,
                    keyboardType: TextInputType.number,
                    hintText: "السعر الإجمالي",
                  ),
                  SizedBox(height: 15.h),
                  CustomTextForm(
                    lapText: "سعر الخامة",
                    controller: material,
                    keyboardType: TextInputType.number,
                    hintText: "سعر الخامة",
                  ),
                  SizedBox(height: 15.h),
                  CustomTextForm(
                    lapText: "سعر الليزر",
                    controller: laser,
                    keyboardType: TextInputType.number,
                    hintText: "سعر الليزر",
                  ),
                  SizedBox(height: 15.h),
                  CustomTextForm(
                    lapText: "ملاحظة",
                    controller: note,
                    hintText: "ملاحظة",
                  ),
                  SizedBox(height: 15.h),
                  _weightCalculatorButton(
                    context,
                    MediaQuery.of(context).size.width >= 900,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingCubit>().addPricingClient(
                        orderId: orderId,
                        totalPrice: double.tryParse(total.text) ?? 0,
                        materialPrice: double.tryParse(material.text) ?? 0,
                        laserPrice: double.tryParse(laser.text) ?? 0,
                        noteClient: note.text,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      minimumSize: Size(double.infinity, 48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      textStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      "إرسال",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= FILE ITEM =================
Widget _fileItem(BuildContext context, String fileUrl) {
  final fileName = Uri.parse(fileUrl).pathSegments.last;

  return InkWell(
    onTap: () => _openFile(fileUrl),
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.open_in_new, size: 18),
        ],
      ),
    ),
  );
}

Future<void> _openFile(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

String _formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year} "
      "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
}
