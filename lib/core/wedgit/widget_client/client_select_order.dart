import 'package:app_alfardos/core/wedgit/widget_client/client_order_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../wedgit_app/custom_text_form.dart';
import 'dart:io';

class ClientSelectOrder extends StatefulWidget {
  final Function(ClientOrderItem) OnAdd;

  const ClientSelectOrder({super.key, required this.OnAdd});

  @override
  State<ClientSelectOrder> createState() => _ClientSelectOrderState();
}
class _ClientSelectOrderState extends State<ClientSelectOrder> {
  final nameController = TextEditingController();
  final numperController = TextEditingController();
  final productController = TextEditingController();
  final amountController = TextEditingController();
  final sizeController = TextEditingController();
  final commentController = TextEditingController();


  String? selectedMaterial;
  List<PlatformFile>? selectedFiles;
  List<XFile>? selectedImages;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        selectedFiles = result.files;
      });
    }
  }

  Future<void> pickImages() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('اختر من الاستوديو'),
                onTap: () async {
                  final List<XFile>? images = await _picker.pickMultiImage();
                  if (images != null) {
                    setState(() {
                      selectedImages = images;
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('استخدام الكاميرا'),
                onTap: () async {
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (photo != null) {
                    setState(() {
                      selectedImages = selectedImages ?? [];
                      selectedImages!.add(photo);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "إنشاء طلب جديد",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25.h),
            CustomTextForm(
              hintText: "الاسم الكامل",
              lapText: "الاسم",
              controller: nameController,
              validator: (a) {
                if ((a ?? '').isEmpty) {
                  return "الاسم مطلوب";
                }
                return null;
              },
            ),

            SizedBox(height: 15.h),
            CustomTextForm(
              hintText: "010*****59",
              lapText: "رقم الهاتف",
              controller: numperController,
              validator: (a) {},
              keyboardType: TextInputType.number,
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
                        borderRadius: BorderRadius.all(Radius.circular(15)),
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
            CustomTextForm(
              hintText: "ادخل الكمية",
              lapText: "الكمية",
              controller: amountController,
              validator: (a) {},
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15.h),
            CustomTextForm(
              hintText: "الطول × العرض (السمك)",
              lapText: "المقاس",
              controller: sizeController,
              validator: (a) {},
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15.h),
            CustomTextForm(
              hintText: "أي ملاحظات أو متطلبات خاصة",
              lapText: "ملاحظات",
              controller: commentController,
              validator: (a) {},
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: pickImages,
                    child: Container(
                      height: 150.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 50.sp,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 8.h),
                            const Text("اضغط لإضافة صورة أو كاميرا"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: InkWell(
                    onTap: pickFiles,
                    child: Container(
                      height: 150.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 50.sp,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 8.h),
                            const Text("اضغط لرفع ملفات"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            if ((selectedFiles != null && selectedFiles!.isNotEmpty) ||
                (selectedImages != null && selectedImages!.isNotEmpty))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedImages != null && selectedImages!.isNotEmpty)
                    ...selectedImages!.map(
                          (img) => ListTile(
                        leading: const Icon(Icons.image),
                        title: Text(img.name),
                      ),
                    ),
                  if (selectedFiles != null && selectedFiles!.isNotEmpty)
                    ...selectedFiles!.map(
                          (file) => ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text(file.name),
                        subtitle: Text("${(file.size / 1024).toStringAsFixed(2)} KB"),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {

                  if (
                      productController.text.isEmpty ||
                      selectedMaterial == null ||
                      amountController.text.isEmpty ||
                      sizeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "⚠️ من فضلك أكمل جميع البيانات المطلوبة قبل إرسال الطلب",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final amount = int.tryParse(amountController.text);
                  final numper = int.tryParse(numperController.text);

                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "⚠️ الكمية يجب أن تكون رقم صحيح أكبر من صفر",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (numper == null || numper <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ رقم الهاتف غير صالح"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  final newClientOrderItem = ClientOrderItem(
                    name: nameController.text,
                    numper: numper,
                    product: productController.text,
                    material: selectedMaterial ?? '',
                    amount: amount,
                    size: sizeController.text,
                    comment: commentController.text,
                    imageFiles: selectedImages
                        ?.where((x) => x.path != null)
                        .map((x) => File(x.path!))
                        .toList(),
                    fileFiles: selectedFiles
                        ?.where((x) => x.path != null)
                        .map((x) => File(x.path!))
                        .toList(),

                  );
                  widget.OnAdd(newClientOrderItem);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ تم إضافة الطلب بنجاح")),
                  );

                  nameController.clear();
                  numperController.clear();
                  productController.clear();
                  amountController.clear();
                  sizeController.clear();
                  commentController.clear();
                  selectedFiles = [];
                  selectedImages = [];
                  selectedMaterial = null;
                  setState(() {});
                },
                icon: const Icon(Icons.send),
                label: Text(
                  'إرسال الطلب',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
