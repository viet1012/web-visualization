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

class _DashboardScreenState extends State<DashboardScreen> {
  final data = ChartDataProvider.getDualBarChartData();

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  late ApiService toolCostService; // Đối tượng ToolCostService

  late Future<List<ToolCostModel>> monthlyDataFuture; // Future cho dữ liệu

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ToolCostProvider>(context, listen: false);
    final String month = "${selectedYear}-${selectedMonth.toString().padLeft(2, '0')}";
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
                DateDisplayWidget(selectedDate: selectedDate),
                SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  width: 160,
                  height: 40, // thêm dòng này!
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildMonthYearDropdown(),
                  ),
                ),
              ],
            ),
            TimeInfoCard(finalTime: "12:00 PM", nextTime: "03:00 PM"),
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
      body: FutureBuilder<List<ToolCostModel>>(
        future: monthlyDataFuture, // Dữ liệu từ API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị Loading khi dữ liệu đang tải
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hiển thị lỗi nếu có lỗi xảy ra
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final monthlyData = snapshot.data!;
            // Kiểm tra xem dữ liệu có rỗng không
            if (monthlyData.isEmpty) {
              return NoDataWidget(
                title: "Chưa có dữ liệu",
                message: "Vui lòng thử lại với khoảng thời gian khác.",
                icon: Icons.search_off,
              );
            }
            // Dữ liệu đã có, hiển thị UI chính
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: [
                      // Hàng 1: Tổng quan
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 8,
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.blue.shade100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ReusableOverviewChart(data: monthlyData),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // Nếu không có dữ liệu
            return NoDataWidget(
              title: "Chưa có dữ liệu",
              message: "Vui lòng thử lại với khoảng thời gian khác.",
              icon: Icons.search_off,
            );
          }
        },
      ),
    );
  }

  Widget _buildMonthYearDropdown() {
    final now = DateTime.now();
    final List<DateTime> options = List.generate(
      24, // số tháng muốn hiển thị (2 năm gần nhất)
      (index) => DateTime(now.year, now.month - index, 1),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateTime>(
          value: selectedDate,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          isExpanded: true,
          dropdownColor: Colors.white,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          items:
              options.map((date) {
                final label = DateFormat('MMM yyyy').format(date); // "Apr 2024"
                return DropdownMenuItem(value: date, child: Text(label));
              }).toList(),
          onChanged: (DateTime? value) {
            if (value != null) {
              setState(() {
                selectedDate = value;
                selectedMonth = value.month;
                selectedYear = value.year;
                monthlyDataFuture = toolCostService.fetchToolCosts(
                  "${selectedYear}-${selectedMonth.toString().padLeft(2, '0')}",
                ); // Load lại dữ liệu khi tháng/năm thay đổi
              });
            }
          },
        ),
      ),
    );
  }
}
