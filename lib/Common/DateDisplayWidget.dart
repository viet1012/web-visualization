import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDisplayWidget extends StatefulWidget {
  const DateDisplayWidget({super.key});

  @override
  State<DateDisplayWidget> createState() => _DateDisplayWidgetState();
}

class _DateDisplayWidgetState extends State<DateDisplayWidget> {
  late DateTime now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _scheduleMidnightUpdate();
  }

  void _scheduleMidnightUpdate() {
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final duration = tomorrow.difference(now);

    _timer = Timer(duration, () {
      setState(() {
        now = DateTime.now(); // cập nhật lại ngày
      });
      _scheduleMidnightUpdate(); // lên lịch tiếp cho hôm sau
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat('MMM-yyyy');
    final dayFormat = DateFormat('d-MMM-yyyy');
    final startOfMonth = DateTime(now.year, now.month, now.day - 1);

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
                monthFormat.format(now),
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
