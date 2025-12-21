import 'package:flutter/material.dart';

class StatusDropdownPage extends StatefulWidget {
  const StatusDropdownPage({super.key, required this.selectValio, required this.status});
  final String selectValio;
  final List<String> status;
  @override
  State<StatusDropdownPage> createState() => _StatusDropdownPageState();
}

class _StatusDropdownPageState extends State<StatusDropdownPage> {

  String selectedStatus = selectValio ;

  final List<String> statusList = status;

  static String get selectValio => selectValio;

  static List<String> get status => status;

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF334155),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.white),
              dropdownColor: const Color(0xFF334155),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              isExpanded: true,
              items: statusList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, textDirection: TextDirection.rtl),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
            ),
          ),
        ),
    );
  }
}
