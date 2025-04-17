import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visualization/Model/ToolCostModel.dart';
import 'API/ApiService.dart';
import 'ChartDataProvider.dart';
import 'Common/BlinkingText.dart';
import 'Common/DateDisplayWidget.dart';
import 'Common/NoDataWidget.dart';
import 'Common/TimeInfoCard.dart';
import 'Overview/ReusableOverviewChart.dart';
import 'Provider/ToolCostProvider.dart';
import 'main.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const DashboardScreen({super.key, required this.onToggleTheme});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final data = ChartDataProvider.getDualBarChartData();
//
//   int selectedMonth = DateTime.now().month;
//   int selectedYear = DateTime.now().year;
//   DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
//   late ApiService toolCostService; // Đối tượng ToolCostService
//
//   List<ToolCostModel> monthlyData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     toolCostService = ApiService();  // Khởi tạo ToolCostService
//     _loadData();  // Gọi hàm để tải dữ liệu từ API
//   }
//
//   Future<void> _loadData() async {
//     final data = await toolCostService.fetchToolCosts("${selectedYear}-${selectedMonth.toString().padLeft(2, '0')}");
//     setState(() {
//       monthlyData = data;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 4,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 BlinkingText(text: 'Cost Monitoring'),
//                 SizedBox(width: 16),
//                 DateDisplayWidget(selectedDate: selectedDate,),
//                 SizedBox(width: 16),
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle
//                   ),
//                   width: 160,
//                   height: 40, // thêm dòng này!
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: _buildMonthYearDropdown(),
//                   ),
//                 ),
//               ],
//             ),
//             TimeInfoCard(
//               finalTime: "12:00 PM",
//               nextTime: "03:00 PM",
//             ),
//           ],
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.brightness_6),
//             onPressed: widget.onToggleTheme,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Wrap(
//               children: [
//                 // Hàng 1: Tổng quan
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Card(
//                     elevation: 8,
//                     shadowColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         side: BorderSide(color: Colors.blue.shade100),
//                       ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: ReusableOverviewChart(data: monthlyData),
//                     ),
//                   ),
//                 ),
//
//                 // SizedBox(
//                 //   width: MediaQuery.of(context).size.width / 2 - 24,
//                 //   child: AspectRatio(
//                 //     aspectRatio: 2,
//                 //     child: Card(
//                 //       elevation: 8,
//                 //       shape: RoundedRectangleBorder(
//                 //         borderRadius: BorderRadius.circular(16),
//                 //       ),
//                 //       child: Padding(
//                 //         padding: const EdgeInsets.all(16),
//                 //         child: PieChart(
//                 //           PieChartData(
//                 //             sections:
//                 //                 ChartDataProvider.getPieChartDataFromDualBarData(),
//                 //             centerSpaceRadius: 1,
//                 //             sectionsSpace: 3,
//                 //             pieTouchData: PieTouchData(enabled: false),
//                 //             startDegreeOffset: -90,
//                 //             borderData: FlBorderData(show: false),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   width: MediaQuery.of(context).size.width / 2 - 24,
//                 //   child: AspectRatio(
//                 //     aspectRatio: 2,
//                 //     child: Card(
//                 //       elevation: 8,
//                 //       shape: RoundedRectangleBorder(
//                 //         borderRadius: BorderRadius.circular(16),
//                 //       ),
//                 //       child: Padding(
//                 //         padding: const EdgeInsets.all(16),
//                 //         child: ReusableDualBarChart(data: data),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   width: MediaQuery.of(context).size.width / 2 - 24,
//                 //   child: AspectRatio(
//                 //     aspectRatio: 2,
//                 //     child: Card(
//                 //       elevation: 8,
//                 //       shape: RoundedRectangleBorder(
//                 //         borderRadius: BorderRadius.circular(16),
//                 //       ),
//                 //       child: Padding(
//                 //         padding: const EdgeInsets.all(16),
//                 //         child: GroupPerformanceCard(),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   height: 400,
//                 //   child: Row(
//                 //     children: [
//                 //       const SizedBox(width: 20),
//                 //       // Biểu đồ Pie - Tổng quan
//                 //       Expanded(
//                 //         flex: 1,
//                 //         child: Card(
//                 //           elevation: 4,
//                 //           child: Padding(
//                 //             padding: const EdgeInsets.all(16.0),
//                 //             child: Column(
//                 //               children: [
//                 //                 const Text(
//                 //                   "Actual vs Target Cost Overview",
//                 //                   style: TextStyle(
//                 //                     fontSize: 18,
//                 //                     fontWeight: FontWeight.bold,
//                 //                   ),
//                 //                 ),
//                 //                 const SizedBox(height: 10),
//                 //                 SizedBox(
//                 //                   height: 300,
//                 //                   child: PieChart(
//                 //                     PieChartData(
//                 //                       sections:
//                 //                           ChartDataProvider.getPieChartDataFromDualBarData(),
//                 //                       centerSpaceRadius: 1,
//                 //                       sectionsSpace: 3,
//                 //                       pieTouchData: PieTouchData(enabled: false),
//                 //                       startDegreeOffset: -90,
//                 //                       borderData: FlBorderData(show: false),
//                 //                     ),
//                 //                   ),
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //
//                 //       const SizedBox(width: 20),
//                 //
//                 //       // Biểu đồ Bar nhỏ hoặc thông tin chi tiết
//                 //       GroupPerformanceCard(),
//                 //
//                 //       const SizedBox(width: 20),
//                 //     ],
//                 //   ),
//                 // ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildMonthYearDropdown() {
//     final now = DateTime.now();
//     final List<DateTime> options = List.generate(
//       24, // số tháng muốn hiển thị (2 năm gần nhất)
//           (index) => DateTime(now.year, now.month - index, 1),
//     );
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade400),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<DateTime>(
//           value: selectedDate,
//           icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
//           isExpanded: true,
//           dropdownColor: Colors.white,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//           items: options.map((date) {
//             final label = DateFormat('MMM yyyy').format(date); // "Apr 2024"
//             return DropdownMenuItem(
//               value: date,
//               child: Text(label),
//             );
//           }).toList(),
//           onChanged: (DateTime? value) {
//             if (value != null) {
//               setState(() {
//                 selectedDate = value;
//                 selectedMonth = value.month;
//                 selectedYear = value.year;
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//
//
// }

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  DateTime _currentDate = DateTime.now(); // Initialize directly
  Timer? _dailyTimer;
  final dayFormat = DateFormat('d-MMM-yyyy');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("After build - Current Date: $_currentDate");
      final provider = Provider.of<ToolCostProvider>(context, listen: false);
      _fetchData(provider);
    });

    _dailyTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      print("[TIMER CHECK] Current Time: $now | Stored Time: $_currentDate");

      if (now.day != _currentDate.day ||
          now.month != _currentDate.month ||
          now.year != _currentDate.year) {
        print("[DATE CHANGED] Detected date change! Refreshing...");

        _currentDate = now;

        if (mounted) {
          final provider = Provider.of<ToolCostProvider>(
            context,
            listen: false,
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedDate = DateTime(now.year, now.month, 1);
              selectedMonth = now.month;
              selectedYear = now.year;
            });
            _fetchData(provider);
          });
        }
      }
    });
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // print("didPopNext");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _dailyTimer?.cancel(); // 🧹 Dọn dẹp khi màn hình bị hủy
    super.dispose();
  }

  String month = "";

  void _fetchData(ToolCostProvider provider) {
    month = "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
    print("Month: $month");
    provider.clearData(); // 👈 Reset trước khi fetch
    provider.fetchToolCosts(month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                BlinkingText(text: 'Cost Monitoring'),
                SizedBox(width: 16),
                DateDisplayWidget(
                  selectedDate: selectedDate,
                  monthYearDropDown: SizedBox(
                    width: 140,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildMonthYearDropdown(),
                    ),
                  ),
                ),
              ],
            ),
            TimeInfoCard(
              finalTime: dayFormat.format(_currentDate), // Ngày hiện tại
              nextTime: dayFormat.format(
                _currentDate.add(const Duration(days: 1)),
              ), // Ngày kế tiếp
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Consumer<ToolCostProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.data.isEmpty) {
            return const NoDataWidget(
              title: "No Data Available",
              message: "Please try again with a different time range.",
              icon: Icons.error_outline,
            );
          }

          return SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.blue.shade100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ReusableOverviewChart(
                            data: provider.data,
                            month: month,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthYearDropdown() {
    final now = DateTime.now();
    final List<DateTime> options = List.generate(
      12,
      (index) => DateTime(now.year, now.month - index, 1),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateTime>(
          value: selectedDate,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
          isExpanded: true,
          underline: SizedBox(),
          // Ẩn dòng dưới
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent,
          ),
          dropdownColor: Colors.white,
          items:
              options.map((date) {
                final label = DateFormat('MMM yyyy').format(date);
                return DropdownMenuItem(value: date, child: Text(label));
              }).toList(),
          onChanged: (DateTime? value) {
            if (value != null) {
              setState(() {
                selectedDate = value;
                selectedMonth = value.month;
                selectedYear = value.year;
                month =
                    "${selectedYear.toString()}-${selectedMonth.toString().padLeft(2, '0')}";
              });
              final provider = Provider.of<ToolCostProvider>(
                context,
                listen: false,
              );
              _fetchData(provider);
            }
          },
        ),
      ),
    );
  }
}
