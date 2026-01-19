
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../client/factuors/client_order/data/model/order_model.dart';
import '../widget_client/order_files_page.dart';

class ShowOrders extends StatelessWidget {
  const ShowOrders({
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
