import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DateDisplayWidget extends StatelessWidget {
  final DateTime selectedDate;

  const DateDisplayWidget({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat('MMM-yyyy');
    final dayFormat = DateFormat('d-MMM-yyyy');

    // Kiểm tra xem tháng đã chọn có phải là tháng hiện tại không
    DateTime startOfMonth;
    if (selectedDate.year == DateTime.now().year && selectedDate.month == DateTime.now().month) {
      // Nếu là tháng hiện tại, lùi 1 ngày so với ngày hiện tại
      startOfMonth = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    } else {
      // Nếu là tháng trước, lấy ngày cuối của tháng trước
       startOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              Text('Month: ', style: TextStyle(fontSize: 18)),
              Text(
                monthFormat.format(selectedDate),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.date_range, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text('MTD: ', style: TextStyle(fontSize: 18)),
              Text(
                dayFormat.format(startOfMonth),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
