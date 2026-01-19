import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/wedgit/Widgit_admin/calculator.dart';
import '../../../../../core/wedgit/Widgit_admin/custom_app_bar.dart';
import '../../../../../core/wedgit/Widgit_admin/pricing_review_button.dart';
import '../../../../../core/wedgit/wedgit_app/custom_text_form.dart';
import '../../data/model/model_prise.dart';
import '../cubit/pricing_cubit.dart';
import '../cubit/pricing_state.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  bool showPricingReviewButton = false;
  DateTime? selectedReceiptDate;

  @override
  void initState() {
    super.initState();

    context.read<SettingCubit>().listenToOrders();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final Map<String, bool> executedOrders = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocListener<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is ConfirmOrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ تم تحويل الأوردر للتنفيذ')),
            );
          }

          if (state is ConfirmOrderFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900.w;

            return Scrollbar(
              thumbVisibility: isDesktop,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1100.w : double.infinity,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 24.w : 15.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                showPricingReviewButton
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 34,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPricingReviewButton =
                                      !showPricingReviewButton;

                                  showPricingReviewButton
                                      ? _controller.forward()
                                      : _controller.reverse();
                                });
                              },
                            ),
                          ),

                          SlideTransition(
                            position: _slideAnimation,
                            child: showPricingReviewButton
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                    child: const PricingReviewButton(),
                                  )
                                : const SizedBox(),
                          ),

                          Row(
                            spacing: 5.w,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 5.w,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "صفحه المهندسين",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isDesktop ? 20.w : 24.w,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Widget _orderCard(BuildContext context, PricingModel order, bool isDesktop) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showPricingReviewButton = true;
          _controller.forward();
        });
      },
      child: Card(
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
                      onPressed: executedOrders[order.orderId] == true
                          ? null
                          : () async {
                              await context
                                  .read<SettingCubit>()
                                  .confirmOrderForExecution(
                                    orderId: order.orderId,
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("✅ تم تحويل الأوردر للتنفيذ"),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              setState(() {
                                executedOrders[order.orderId] = true;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: executedOrders[order.orderId] == true
                            ? Colors.orange.shade200
                            : Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
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
    final dateOfReceipt = TextEditingController();

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
                    lapText: "السعر الإجمالي",
                    controller: total,
                    keyboardType: TextInputType.number,
                    hintText: "السعر الإجمالي",
                  ),
                  SizedBox(height: 15.h),
                  CustomTextForm(
                    lapText: "تاريخ الاستلام",
                    controller: dateOfReceipt,
                    keyboardType: TextInputType.text,
                    hintText: "تاريخ الاستلام",
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
                        totalPrice: (double.tryParse(total.text) ?? 0).toInt(),
                        materialPrice: (double.tryParse(material.text) ?? 0).toInt(),
                        laserPrice: (double.tryParse(laser.text) ?? 0).toInt(),

                        noteClient: note.text,
                        dateOfReceipt: dateOfReceipt.text,
                      );
                      Navigator.pop(context);
                      total.dispose();
                      material.dispose();
                      laser.dispose();
                      note.dispose();
                      dateOfReceipt.dispose();

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
