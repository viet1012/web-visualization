import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Common/CustomAppBar.dart';
import '../Model/DualBarData.dart';
import '../Model/StackBarData.dart';

class SubDetailScreen extends StatefulWidget {
  final DualBarData item;

  const SubDetailScreen({super.key, required this.item});

  @override
  State<SubDetailScreen> createState() => _SubDetailScreenState();
}

class _SubDetailScreenState extends State<SubDetailScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  List<StackBarData> monthlyData = [];

  @override
  void initState() {
    super.initState();
    monthlyData = _generateMonthlyData(selectedYear, selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    final status = _getStatus(widget.item);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Scaffold(
      appBar: CustomAppBar(
        titleText: '${widget.item.tiltle} ',
        finalTime: "12:00 PM",
        nextTime: "03:00 PM",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildMonthDropdown(),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildYearDropdown(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Target vs Actual (by day)',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(statusIcon, color: statusColor),
              ],
            ),
            const SizedBox(height: 12),
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
                  labelStyle: const TextStyle(fontSize: 18),
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
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String status, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(_getStatusIcon(status), color: color, size: 32),
        title: Text(
          'Status: $status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: const Text('Monitoring performance by day'),
      ),
    );
  }

  List<StackBarData> _generateMonthlyData(int year, int month) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    return List.generate(daysInMonth, (index) {
      final day = 'Day ${index + 1}';
      final target = 100;
      final actual = 80 + (index % 7) * 10;
      return StackBarData(day: day, target: target, actual: actual);
    });
  }

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
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
      LineSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, _) => d.day,
        yValueMapper: (d, _) => d.actual > d.target ? d.actual : 0,
        name: 'Exceeded Line',
        color: Colors.redAccent,
        markerSettings: const MarkerSettings(isVisible: true),
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
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(isVisible: false),
        dashArray: [6, 3],
      ),
      LineSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, index) => d.day,
        yValueMapper: (d, index) => cumulativeTarget[index],
        yAxisName: 'CumulativeAxis',
        name: 'Cumulative Target',
        color: Colors.orange,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(isVisible: false),
        dashArray: [4, 4],
      ),
    ];
  }

  double _getMaxYAxis(List<StackBarData> data) {
    final maxVal = data
        .map((e) => e.actual > e.target ? e.actual : e.target)
        .reduce((a, b) => a > b ? a : b);
    return (maxVal * 1.3).ceilToDouble();
  }

  double _getMaxCumulativeYAxis(List<StackBarData> data) {
    double totalActual = 0;
    double totalTarget = 0;
    for (var item in data) {
      totalActual += item.actual;
      totalTarget += item.target;
    }
    final maxCumulative = totalActual > totalTarget ? totalActual : totalTarget;
    return (maxCumulative * 1.1).ceilToDouble();
  }

  String _getStatus(DualBarData item) {
    if (item.actual > item.target) return 'Over Target';
    if (item.actual < item.target) return 'Under Target';
    return 'Target Achieved';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Over Target':
        return Colors.red;
      case 'Target Achieved':
        return Colors.green;
      case 'Under Target':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Over Target':
        return Icons.trending_up;
      case 'Target Achieved':
        return Icons.check_circle;
      case 'Under Target':
        return Icons.trending_down;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildMonthDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedMonth,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          isExpanded: true,
          dropdownColor: Colors.white,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          items: List.generate(12, (index) {
            final date = DateTime(0, index + 1);
            final monthName = DateFormat.MMM().format(date); // ví dụ: 'Apr'
            return DropdownMenuItem(value: index + 1, child: Text(monthName));
          }),
          onChanged: (value) {
            setState(() {
              selectedMonth = value!;
              monthlyData = _generateMonthlyData(selectedYear, selectedMonth);
            });
          },
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    final currentYear = DateTime.now().year;
    final List<int> yearOptions = List.generate(
      5,
      (index) => currentYear - index,
    ); // ví dụ: 2025, 2024, ...

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedYear,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          isExpanded: true,
          dropdownColor: Colors.white,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          items:
              yearOptions.map((year) {
                return DropdownMenuItem(value: year, child: Text('$year'));
              }).toList(),
          onChanged: (value) {
            setState(() {
              selectedYear = value!;
              monthlyData = _generateMonthlyData(selectedYear, selectedMonth);
            });
          },
        ),
      ),
    );
  }
}
