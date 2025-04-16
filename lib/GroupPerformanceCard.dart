import 'package:flutter/material.dart';

import 'ChartDataProvider.dart';

class GroupPerformanceCard extends StatelessWidget {
  const GroupPerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ChartDataProvider.getDualBarChartData();

    // Sắp xếp theo actual / target giảm dần
    data.sort((a, b) =>
    ((b.actual / b.target).compareTo(a.actual / a.target)));

    return Column(
      children: [
        const Text(
          "Group Performance Summary",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final status = item.actual > item.target
                  ? 'Over'
                  : item.actual == item.target
                  ? 'Met'
                  : 'Below';

              final statusColor = item.actual > item.target
                  ? Colors.red
                  : item.actual == item.target
                  ? Colors.green
                  : Colors.orange;

              return   Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        item.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 16,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (item.actual / item.target).clamp(0.0, 1.5),
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50, // 👈 Thêm phần hiển thị %
                      child: Text(
                        "${((item.actual / item.target) * 100).toStringAsFixed(1)}%", // làm tròn 1 số thập phân
                        style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );

            },
          ),
        ),
      ],
    );
  }
}
