import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeightCalculator extends StatefulWidget {
  const WeightCalculator({super.key});

  @override
  State<WeightCalculator> createState() => _WeightCalculatorState();
}

class _WeightCalculatorState extends State<WeightCalculator> {
  String? selectedMaterial;
  String? selectedShape;
  double density = 0;

  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final thicknessController = TextEditingController();
  final priceController = TextEditingController();

  double totalPrice = 0.0;
  double result = 0.0;

  void calculateWeight() {
    double? length = double.tryParse(lengthController.text);
    double? width = double.tryParse(widthController.text);
    double? thickness = double.tryParse(thicknessController.text);
    double? pricePerKg = double.tryParse(priceController.text);

    if (length == null ||
        width == null ||
        thickness == null ||
        pricePerKg == null ||
        selectedMaterial == null ||
        selectedShape == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ من فضلك أدخل كل القيم أولاً")),
      );
      return;
    }

    switch (selectedMaterial) {
      case 'حديد':
        density = 7850;
        break;
      case 'ألمنيوم':
        density = 2700;
        break;
      case 'استنلس':
        density = 8000;
        break;
    }

    double l = length / 1000;
    double w = width / 1000;
    double t = thickness / 1000;

    double weight = 0.0;

    switch (selectedShape) {
      case 'لوح':
        weight = l * w * t * density;
        break;

      case 'قضيب':
        double radius = w / 2;
        weight = pi * pow(radius, 2) * l * density;
        break;

      case 'أنبوب':
        double outerRadius = w / 2;
        double innerRadius = outerRadius - t;
        if (innerRadius < 0) innerRadius = 0;
        weight =
            pi * (pow(outerRadius, 2) - pow(innerRadius, 2)) * l * density;
        break;
    }

    setState(() {
      result = weight;
      totalPrice = result * pricePerKg;
    });
  }


  void resetFields() {
    setState(() {
      selectedMaterial = null;
      selectedShape = null;
      lengthController.clear();
      widthController.clear();
      thicknessController.clear();
      priceController.clear();
      result = 0.0;
      totalPrice = 0.0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF101826),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedMaterial,
                hint: const Text("اختر المادة",
                    style: TextStyle(color: Colors.white)),
                items: const [
                  DropdownMenuItem(
                      value: 'حديد',
                      child: Text('حديد', style: TextStyle(color: Colors.black))),
                  DropdownMenuItem(
                      value: 'ألمنيوم',
                      child:
                      Text('ألمنيوم', style: TextStyle(color: Colors.black))),
                  DropdownMenuItem(
                      value: 'استنلس',
                      child:
                      Text('استنلس', style: TextStyle(color: Colors.black))),
                ],
                selectedItemBuilder: (context) => const [
                  Text('حديد', style: TextStyle(color: Colors.white)),
                  Text('ألمنيوم', style: TextStyle(color: Colors.white)),
                  Text('استنلس', style: TextStyle(color: Colors.white)),
                ],
                decoration: _inputDecoration(),
                dropdownColor: Colors.white,
                onChanged: (val) => setState(() => selectedMaterial = val),
              ),
              SizedBox(height: 10.h),

              DropdownButtonFormField<String>(
                value: selectedShape,
                hint: const Text("اختر الشكل",
                    style: TextStyle(color: Colors.white)),
                items: const [
                  DropdownMenuItem(
                      value: 'لوح',
                      child: Text('لوح', style: TextStyle(color: Colors.black))),
                  DropdownMenuItem(
                      value: 'أنبوب',
                      child:
                      Text('أنبوب', style: TextStyle(color: Colors.black))),
                  DropdownMenuItem(
                      value: 'قضيب',
                      child:
                      Text('قضيب', style: TextStyle(color: Colors.black))),
                ],
                selectedItemBuilder: (context) => const [
                  Text('لوح', style: TextStyle(color: Colors.white)),
                  Text('أنبوب', style: TextStyle(color: Colors.white)),
                  Text('قضيب', style: TextStyle(color: Colors.white)),
                ],
                decoration: _inputDecoration(),
                dropdownColor: Colors.white,
                onChanged: (val) => setState(() => selectedShape = val),
              ),
              SizedBox(height: 10.h),

              TextFormField(
                controller: lengthController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration:
                _inputDecoration().copyWith(hintText: "الطول (مم)"),
              ),
              SizedBox(height: 10.h),

              TextFormField(
                controller: widthController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration().copyWith(
                    hintText: selectedShape == 'قضيب' || selectedShape == 'أنبوب'
                        ? "القطر الخارجي (مم)"
                        : "العرض (مم)"),
              ),
              SizedBox(height: 10.h),

              TextFormField(
                controller: thicknessController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration().copyWith(
                    hintText: selectedShape == 'أنبوب'
                        ? "سمك الأنبوب (مم)"
                        : "السمك (مم)"),
              ),
              SizedBox(height: 10.h),

              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration:
                _inputDecoration().copyWith(hintText: "سعر الكيلو"),
              ),
              SizedBox(height: 20.h),

              ElevatedButton.icon(
                onPressed: calculateWeight,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.calculate, color: Colors.white),
                label: const Text(
                  "احسب الوزن",
                  style: TextStyle(color: Colors.white, fontSize: 22,fontWeight:FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.h),

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF122950),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "الوزن المحسوب",
                      style: TextStyle(color: Colors.white70, fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${result.toStringAsFixed(2)} كـج",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.h,),
              if (totalPrice > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "السعر النهائي",
                        style: TextStyle(color: Colors.white70, fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${totalPrice.toStringAsFixed(2)} ج.م",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1B2431),
      hintStyle: const TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blueAccent),
      ),
    );
  }
}
