import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import '../../../client/factuors/client_order/perthon/cubit/order_cubit.dart';
import '../../../client/factuors/client_order/perthon/cubit/order_state.dart';
import '../wedgit_app/coloers.dart';

class OrderFilesPage extends StatelessWidget {
  final List<String> images;
  final List<String> files;

  const OrderFilesPage({
    Key? key,
    required this.images,
    required this.files,
  }) : super(key: key);

  bool isImage(String url) {
    return url.endsWith(".jpg") ||
        url.endsWith(".jpeg") ||
        url.endsWith(".png") ||
        url.endsWith(".gif");
  }

  bool isPdf(String url) => url.endsWith(".pdf");
  bool isWord(String url) => url.endsWith(".doc") || url.endsWith(".docx");

  @override
  Widget build(BuildContext context) {
    final allFiles = [...images, ...files];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 50.w),
                      Container(
                        decoration: BoxDecoration(
                          color: MyColorsApp.iconColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.factory,
                            color: Colors.white, size: 24.sp),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "مصنع الفردوس لتشغيل المعادن",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      "نظام إدارة الإنتاج والطلبات",
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is FileDownloadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is FileDownloadSuccess) {
            OpenFile.open(state.savedPath);
          }
        },

        builder: (context, state) {
          return Column(
            children: [
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  "الملفات المرفوعه",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp,
                    color: Colors.white,
                  ),
                ),
              ),

              Expanded(
                child: allFiles.isEmpty
                    ? Center(
                    child: Text("لا توجد ملفات مرفوعة",
                        style: TextStyle(
                            color: Colors.white, fontSize: 18.sp)))
                    : ListView.builder(
                  itemCount: allFiles.length,
                  itemBuilder: (context, index) {
                    final fileUrl = allFiles[index];

                    final isCurrentLoading =
                    (state is FileDownloadLoading &&
                        state.url == fileUrl);

                    return ListTile(
                      leading: Icon(
                        isImage(fileUrl)
                            ? Icons.image
                            : isPdf(fileUrl)
                            ? Icons.picture_as_pdf
                            : Icons.insert_drive_file,
                        color: Colors.blue,
                      ),
                      title: Text(
                        fileUrl.split('/').last,
                        style: TextStyle(color: Colors.white),
                      ),

                      onTap: () {
                        if (isImage(fileUrl)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ImageViewerScreen(imageUrl: fileUrl),
                            ),
                          );
                        } else {
                          context
                              .read<OrderCubit>()
                              .downloadFile(fileUrl);
                        }
                      },

                      trailing: isCurrentLoading
                          ? SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          value: state.progress,
                          strokeWidth: 3,
                          color: Colors.blue,
                        ),
                      )
                          : const Icon(Icons.download,
                          color: Colors.white),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewerScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("عرض الصورة")),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
