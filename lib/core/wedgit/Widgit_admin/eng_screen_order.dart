import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../admin/factuors/eng_screen/perthon/cubit/eng_cubit.dart';
import '../../../client/factuors/client_order/data/model/order_model.dart';
import '../widget_client/order_files_page.dart';

class EngScreenOrder extends StatelessWidget {
  const EngScreenOrder({
    super.key,
    required this.order,
    this.onDelete,
    this.isEngineer,
  });

  final OrderModel order;
  final VoidCallback? onDelete;
  final bool? isEngineer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border.all(color: Colors.white30, width: 2.w),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الاسم: ${order.name}",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "الهاتف: ${order.numper}",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "المنتج: ${order.prodact}",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "المادة: ${order.matrial}",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "الكمية: ${order.quantity}",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15.h),

          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _showTextDialog(context, "المقاس", order.size),
                  child: _iconContainer(Icons.remove_red_eye),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: InkWell(
                  onTap: () => _showTextDialog(context, "ملاحظات", order.desc),
                  child: _iconContainer(Icons.receipt_long_outlined),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderFilesPage(
                        images: order.images,
                        files: order.files,
                      ),
                    ),
                  ),
                  child: _iconContainer(Icons.download_outlined),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: InkWell(
                  onTap: onDelete,
                  child: _iconContainer(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          ),

          if (isEngineer == true) ...[
            SizedBox(height: 10.h),
            ElevatedButton.icon(
              onPressed: () {
                final TextEditingController reviewController =
                    TextEditingController();

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: Text(
                      "مراجعة الرسم مع العميل",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: TextField(
                      controller: reviewController,
                      maxLines: 3,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "اكتب ملاحظتك هنا...",
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "إلغاء",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final text = reviewController.text.trim();
                          if (text.isNotEmpty) {
                            try {
                              await context
                                  .read<EngOrderCubit>()
                                  .sendMessageToChat(
                                    orderId: order.id,
                                    senderId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    senderType: 'engineer',
                                    text: text,
                                    messageType: 'review clint',
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم إرسال الملاحظة للعميل'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('حدث خطأ: $e')),
                              );
                            }
                          }
                          Navigator.pop(context);
                        },
                        child: Text("إرسال"),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.design_services),
              label: Text(
                "إرسال مراجعة رسم / تأكيد العميل",
                style: TextStyle(fontSize: 15.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 45),
              ),
            ),

            SizedBox(height: 10.h),
            ElevatedButton.icon(
              onPressed: () {
                openSendDialog(
                  context: context,
                  cubit: context.read<EngOrderCubit>(),
                  orderId: order.id,
                  type: "eng review price",
                );
              },
              icon: Icon(Icons.attach_money),
              label: Text("رفع ملف التسعير", style: TextStyle(fontSize: 15.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 45),
              ),
            ),

          ],
        ],
      ),
    );
  }

  Widget _iconContainer(IconData icon, {Color color = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(8),
      child: Icon(icon, color: color, size: 18.sp),
    );
  }

  void _showTextDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: TextStyle(color: Colors.white)),
        content: Text(content, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إغلاق", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

void openSendDialog({
  required BuildContext context,
  required EngOrderCubit cubit,
  required String orderId,
  required String type,
}) {
  final TextEditingController noteController = TextEditingController();
  List<File> selectedImages = [];
  List<File> selectedFiles = [];

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          type == "review" ? "إرسال مراجعة" : "رفع ملف التسعير",
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: noteController,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "اكتب ملاحظة (اختياري)",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final XFile? picked = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (picked != null) {
                    setState(() => selectedImages.add(File(picked.path)));
                  }
                },
                icon: Icon(Icons.image),
                label: Text("إضافة صورة"),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                  );
                  if (result != null) {
                    setState(
                      () => selectedFiles.addAll(
                        result.paths.map((p) => File(p!)),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.attach_file),
                label: Text("إضافة ملف"),
              ),
              SizedBox(height: 10.h),
              Text(
                "الصور: ${selectedImages.length} | الملفات: ${selectedFiles.length}",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.sendReviewOrPricing(
                orderId: orderId,
                type: type,
                note: noteController.text.trim(),
                files: selectedFiles,
                images: selectedImages,
              );
              Navigator.pop(context);
            },
            child: Text("إرسال"),
          ),
        ],
      ),
    ),
  );
}
