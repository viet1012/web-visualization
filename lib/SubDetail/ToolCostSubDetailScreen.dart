import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visualization/Model/ToolCostDetailModel.dart';
import 'package:visualization/Model/ToolCostSubDetailModel.dart';
import '../API/ApiService.dart';
import '../Common/CustomAppBar.dart';
import '../Common/CustomToolCostAppBar.dart';
import '../Common/ToolCostStatusHelper.dart';
import '../Model/ToolCostModel.dart';
import '../Model/StackBarData.dart';
import '../Provider/ToolCostProvider.dart';

class ToolCostSubDetailScreen extends StatefulWidget {
  final ToolCostModel item;
  final ToolCostDetailModel detail;
  const ToolCostSubDetailScreen({super.key, required this.item, required this.detail});

  @override
  State<ToolCostSubDetailScreen> createState() => _ToolCostSubDetailScreenState();
}

class _ToolCostSubDetailScreenState extends State<ToolCostSubDetailScreen> {

  List<StackBarData> monthlyData = [];
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  // @override
  // void initState() {
  //   super.initState();
  //   monthlyData = _generateMonthlyData(selectedYear, selectedMonth);
  // }
  @override
  void initState() {
    super.initState();
    _loadDetailData();
  }

  Future<void> _loadDetailData() async {
    final provider = context.read<ToolCostProvider>();
    final month = DateFormat('yyyy-MM').format(selectedDate);

    // await provider.fetchToolCostsSubDetail(month, widget.item.title, widget.detail.title);
    List<ToolCostSubDetailModel> detailsData = await ApiService()
        .fetchToolCostsSubDetail(month, widget.item.title, widget.detail.title);
    setState(() {
      monthlyData = _convertToStackBarData(detailsData);
    });
  }

  List<StackBarData> _convertToStackBarData(List<ToolCostSubDetailModel> list) {
    return list.map((e) {
      final day = ' ${e.date.day}';
      return StackBarData(
        day: day,
        actual: e.act,
        target: e.targetAdjust, // hoặc e.fcORG nếu bạn muốn dùng giá trị gốc
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<ToolCostProvider>(); // 👈 lấy dữ liệu từ Provider


    final status = ToolCostStatusHelper.getStatus(widget.item);
    final statusColor = ToolCostStatusHelper.getStatusColor(status);
    final statusIcon = ToolCostStatusHelper.getStatusIcon(status);

    return Scaffold(

      appBar: CustomToolCostAppBar(
        titleText: '${widget.item.title} ',
        selectedDate: selectedDate,

        onDateChanged: (newDate) async {
          setState(() {
            selectedDate = newDate;
            selectedMonth = newDate.month;
            selectedYear = newDate.year;
          });

          await _loadDetailData();
        },


        currentDate: provider.lastFetchedDate,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Target vs Actual (by day)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(statusIcon, color: statusColor,size: 24,),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: SfCartesianChart(
                margin: const EdgeInsets.all(0),
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  labelRotation: -45,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: _getMaxYAxis(monthlyData),
                  interval: 20,
                  labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                axes: <ChartAxis>[
                  NumericAxis(
                    name: 'CumulativeAxis',
                    opposedPosition: true,
                    minimum: 0,
                    maximum: _getMaxCumulativeYAxis(monthlyData),
                    interval: 200,
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ],
                series: _buildStackedSeries(monthlyData),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildLegendItem(color: Colors.green, label: 'Target Achieved', isActual: true),
                  _buildLegendItem(color: Colors.red, label: 'Actual > Target (Negative)'),
                  _buildLegendItem(color: Colors.blue, label: 'Cumulative Actual'),
                  _buildLegendItem(color: Colors.orange, label: 'Cumulative Target'),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  // Demo Data for Stacked Bar Chart
  // List<StackBarData> _generateMonthlyData(int year, int month) {
  //   final daysInMonth = DateUtils.getDaysInMonth(year, month);
  //   return List.generate(daysInMonth, (index) {
  //     final day = 'Day ${index + 1}';
  //     final target = 100;
  //     final actual = 80 + (index % 7) * 10;
  //     return StackBarData(day: day, target: target, actual: actual);
  //   });
  // }

  List<CartesianSeries<StackBarData, String>> _buildStackedSeries(
    List<StackBarData> data,
  ) {
    List<double> cumulativeActual = [];
    List<double> cumulativeTarget = [];

    double totalActual = 0;
    double totalTarget = 0;

    for (var item in data) {
      totalActual += item.actual;
      totalTarget += item.target;
      cumulativeActual.add(totalActual);
      cumulativeTarget.add(totalTarget);
    }

    return <CartesianSeries<StackBarData, String>>[
      StackedColumnSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, _) => d.day,
        yValueMapper: (d, _) => d.actual > d.target ? d.target : d.actual,
        color: Colors.green,
        name: 'Within Target',
        width: 0.7,

        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      LineSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, _) => d.day,
        yValueMapper: (d, _) => d.actual > d.target ? d.actual : 0,
        name: 'Exceeded Line',
        color: Colors.redAccent,
        markerSettings: const MarkerSettings(isVisible: true),
        width: 4,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 20, // 👈 Tùy chỉnh kích thước nếu cần
          ),
        ),
      ),
      LineSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, index) => d.day,
        yValueMapper: (d, index) => cumulativeActual[index],
        yAxisName: 'CumulativeAxis',
        name: 'Cumulative Actual',
        color: Colors.blue,
        width: 4,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        dashArray: [0, 0],
        dataLabelMapper: (d, index) {
          return index == data.length - 1
              ? cumulativeActual[index].toStringAsFixed(1)
              : '';
        },
      ),
      LineSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, index) => d.day,
        yValueMapper: (d, index) => cumulativeTarget[index],
        yAxisName: 'CumulativeAxis',
        name: 'Cumulative Target',
        color: Colors.orange,
        width: 4,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        dashArray: [0, 0],
        dataLabelMapper: (d, index) {
          return index == data.length - 1
              ? cumulativeActual[index].toStringAsFixed(1)
              : '';
        },
      ),
    ];
  }

  double _getMaxYAxis(List<StackBarData> data) {
    if (data.isEmpty) return 100; // hoặc 0, hoặc 1 — tuỳ bạn muốn hiển thị gì khi không có dữ liệu

    final maxVal = data
        .map((e) => e.actual > e.target ? e.actual : e.target)
        .reduce((a, b) => a > b ? a : b);

    return (maxVal * 1.3).ceilToDouble();
  }

  double _getMaxCumulativeYAxis(List<StackBarData> data) {
    if (data.isEmpty) return 100; // fallback nếu không có dữ liệu

    double totalActual = 0;
    double totalTarget = 0;
    for (var item in data) {
      totalActual += item.actual;
      totalTarget += item.target;
    }
    final maxCumulative = totalActual > totalTarget ? totalActual : totalTarget;
    return (maxCumulative * 1.1).ceilToDouble();
  }




  Widget _buildLegendItem({required Color color, required String label, bool isActual = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: isActual ? BoxShape.rectangle : BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 18)),
      ],
    );
  }


}
