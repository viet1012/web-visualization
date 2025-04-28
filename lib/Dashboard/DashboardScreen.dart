import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Common/CustomToolCostAppBar.dart';
import '../Overview/ToolCostOverviewScreen.dart';
import '../Provider/DateProvider.dart';
import '../Provider/ToolCostProvider.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const DashboardScreen({super.key, required this.onToggleTheme});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final toolCostProvider =
        context.watch<ToolCostProvider>(); // 👈 lấy dữ liệu từ Provider
    final dateProvider =
        context.watch<DateProvider>(); // 👈 lấy ngày từ Provider
    return Scaffold(
      appBar: CustomToolCostAppBar(
        titleText: "Cost Monitoring",
        selectedDate: dateProvider.selectedDate,
        // 👈 lấy selectedDate từ Provider
        onDateChanged: (newDate) {
          context.read<DateProvider>().updateDate(
            newDate,
          ); // 👈 chỉ cần gọi update
        },
        currentDate: toolCostProvider.lastFetchedDate,
        onToggleTheme: widget.onToggleTheme,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            children: [
              // Hàng 1: Tổng quan
              SizedBox(
                height: MediaQuery.of(context).size.height * .95,
                // height: MediaQuery.of(context).size.height /2 -20,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.blue.shade100),
                  ),
                  child: ToolCostOverviewScreen(
                    onToggleTheme: widget.onToggleTheme,
                    selectedDate: dateProvider.selectedDate,
                  ),
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
