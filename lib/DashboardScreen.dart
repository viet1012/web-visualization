import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'ChartDataProvider.dart';
import 'DualBarChart.dart';
import 'GroupPerformanceCard.dart';
import 'StatCard.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cost Monitoring',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Final update: ",
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  "Next update: ",
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Hàng 1: Tổng quan
                Card(
                  elevation: 8, // Tăng độ sâu của shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Bo góc của Card
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    // Khoảng cách giữa nội dung bên trong Card và viền Card
                    child: DualBarChart(),
                  ),
                ),
                // SizedBox(
                //   height: 400,
                //   child: Row(
                //     children: [
                //       const SizedBox(width: 20),
                //       // Biểu đồ Pie - Tổng quan
                //       Expanded(
                //         flex: 1,
                //         child: Card(
                //           elevation: 4,
                //           child: Padding(
                //             padding: const EdgeInsets.all(16.0),
                //             child: Column(
                //               children: [
                //                 const Text(
                //                   "Actual vs Target Cost Overview",
                //                   style: TextStyle(
                //                     fontSize: 18,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 const SizedBox(height: 10),
                //                 SizedBox(
                //                   height: 300,
                //                   child: PieChart(
                //                     PieChartData(
                //                       sections:
                //                           ChartDataProvider.getPieChartDataFromDualBarData(),
                //                       centerSpaceRadius: 1,
                //                       sectionsSpace: 3,
                //                       pieTouchData: PieTouchData(enabled: false),
                //                       startDegreeOffset: -90,
                //                       borderData: FlBorderData(show: false),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //       const SizedBox(width: 20),
                //
                //       // Biểu đồ Bar nhỏ hoặc thông tin chi tiết
                //       GroupPerformanceCard(),
                //
                //       const SizedBox(width: 20),
                //     ],
                //   ),
                // ),
                // const Row(
                //   children: [
                //     Expanded(
                //       child: StatCard(
                //         title: "For Manager",
                //         value: "12,345",
                //         color: Colors.blue,
                //       ),
                //     ),
                //     Expanded(
                //       child: StatCard(
                //         title: "Revenue",
                //         value: "\$48,234",
                //         color: Colors.green,
                //       ),
                //     ),
                //     Expanded(
                //       child: StatCard(
                //         title: "For Leader",
                //         value: "1,234",
                //         color: Colors.orange,
                //       ),
                //     ),
                //     Expanded(
                //       child: StatCard(
                //         title: "For Staff",
                //         value: "3.2%",
                //         color: Colors.purple,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 20),

                // Hàng 2: Biểu đồ đường và bánh
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
