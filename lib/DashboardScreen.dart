import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visualization/Model/ToolCostModel.dart';
import 'API/ApiService.dart';
import 'ChartDataProvider.dart';
import 'Common/BlinkingText.dart';
import 'Common/DateDisplayWidget.dart';
import 'Common/MonthYearDropdown.dart';
import 'Common/NoDataWidget.dart';
import 'Common/TimeInfoCard.dart';
import 'Overview/ToolCostOverviewChart.dart';
import 'Overview/ToolCostOverviewScreen.dart';
import 'Provider/ToolCostProvider.dart';
import 'main.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const DashboardScreen({super.key, required this.onToggleTheme});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            children: [
              // Hàng 1: Tổng quan
              SizedBox(
                height:  MediaQuery.of(context).size.height ,
                  width: MediaQuery.of(context).size.width  ,
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.blue.shade100),
                    ),
                  child: ToolCostOverviewScreen(onToggleTheme: widget.onToggleTheme),
                ),
              ),

              // SizedBox(
              //   width: MediaQuery.of(context).size.width / 2 - 24,
              //   child: AspectRatio(
              //     aspectRatio: 2,
              //     child: Card(
              //       elevation: 8,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(16),
              //         child: PieChart(
              //           PieChartData(
              //             sections:
              //                 ChartDataProvider.getPieChartDataFromDualBarData(),
              //             centerSpaceRadius: 1,
              //             sectionsSpace: 3,
              //             pieTouchData: PieTouchData(enabled: false),
              //             startDegreeOffset: -90,
              //             borderData: FlBorderData(show: false),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width / 2 - 24,
              //   child: AspectRatio(
              //     aspectRatio: 2,
              //     child: Card(
              //       elevation: 8,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(16),
              //         child: ReusableDualBarChart(data: data),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width / 2 - 24,
              //   child: AspectRatio(
              //     aspectRatio: 2,
              //     child: Card(
              //       elevation: 8,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(16),
              //         child: GroupPerformanceCard(),
              //       ),
              //     ),
              //   ),
              // ),
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
              // ),
            ],
          ),
        ),
      ),
    );
  }




}

