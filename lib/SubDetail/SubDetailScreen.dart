import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Model/DualBarData.dart';
import '../Model/StackBarData.dart';

class SubDetailScreen extends StatelessWidget {
  final DualBarData item;

  const SubDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final status = _getStatus(item);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    // Giả lập dữ liệu từng ngày trong tuần từ 1 item tổng

    final List<StackBarData> monthlyData = List.generate(30, (index) {
      final day = 'Day ${index + 1}';
      final target = 100;
      final actual = 80 + (index % 7) * 10; // ví dụ: giả lập dao động actual
      return StackBarData(day: day, target: target, actual: actual);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: statusColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${item.tiltle} Overview'),
            Icon(statusIcon),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(status, statusColor),
            const SizedBox(height: 24),
            const Text(
              'Target vs Actual (by day)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: SfCartesianChart(
                margin: const EdgeInsets.all(0),
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  labelRotation: -45,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: _getMaxYAxis(monthlyData),
                  interval: 20,
                  labelStyle: const TextStyle(fontSize: 16),
                ),
                axes: <ChartAxis>[
                  NumericAxis( // cho lũy kế
                    name: 'CumulativeAxis',
                    opposedPosition: true,
                    minimum: 0,
                    maximum: _getMaxCumulativeYAxis(monthlyData), // mới
                    interval: 200,
                    labelStyle: const TextStyle(fontSize: 14, color: Colors.blue),
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
        subtitle: const Text('Monitoring performance for each weekday'),
      ),
    );
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
    return (maxCumulative * 1.1).ceilToDouble(); // cộng thêm 10% để có khoảng trống
  }


  List<CartesianSeries<StackBarData, String>> _buildStackedSeries(
    List<StackBarData> data,
  ) {
    // Tính lũy kế target và actual
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
      // Phần trong target
      StackedColumnSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, _) => d.day,
        yValueMapper: (d, _) => d.actual > d.target ? d.target : d.actual,
        color: Colors.green,
        name: 'Within Target',
        width: 0.55,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),

      // Phần vượt target
      LineSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, _) => d.day,
        yValueMapper: (d, _) => d.actual > d.target ? d.actual : 0,
        name: 'Exceeded Line',
        color: Colors.redAccent,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),

      // Lũy kế actual
      LineSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, index) => d.day ,
        yValueMapper: (d, index) => cumulativeActual[index],
        yAxisName: 'CumulativeAxis', // Gán vào đây
        name: 'Cumulative Actual',
        color: Colors.blue,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(isVisible: false),
        dashArray: [6, 3], // cho hiệu ứng đường gạch
      ),

      // Lũy kế target
      LineSeries<StackBarData, String>(
        dataSource: data,
        xValueMapper: (d, index) => d.day,
        yValueMapper: (d, index) => cumulativeTarget[index],
        yAxisName: 'CumulativeAxis', // Gán vào đây
        name: 'Cumulative Target',
        color: Colors.orange,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(isVisible: false),
        dashArray: [4, 4],
      ),
    ];
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
}
