import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'Common/ReusableDualBarChart.dart';
import 'DualBarChart.dart';
import 'Model/DualBarData.dart';
import 'Model/TargetActualData.dart';

class DetailScreen extends StatelessWidget {
  final DualBarData item;

  const DetailScreen({super.key, required this.item});



  @override
  Widget build(BuildContext context) {

    List<DualBarData> getDualBarChartData=
    [
      DualBarData('PR_PRO', 35, 43 ),  // Thực tế > Target => Âm
      DualBarData('MO_PRO', 28, 49),  // Đạt
      DualBarData('GU_PRO', 25, 30),  // Chưa đạt
      DualBarData('MA', 40, 40),  // Đạt
      DualBarData('TE', 42, 40),  // Âm
      DualBarData('COMMON', 35, 35),  // Chưa đạt
      DualBarData('COMMON', 35, 35),  // Chưa đạt
      DualBarData('COMMON', 35, 35),  // Chưa đạt
      DualBarData('COMMON', 35, 35),  // Chưa đạt
      DualBarData('COMMON', 35, 35),  // Chưa đạt
      DualBarData('COMMON', 35, 35),  // Chưa đạt
      DualBarData('COMMON', 35, 35),  // Chưa đạt

    ];

    final status = _getStatus(item);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Scaffold(
      appBar: AppBar(
        title: Text('${item.tiltle} Detail'),
        backgroundColor: statusColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3, // Chiếm 40% chiều rộng
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Target", "${item.target} K\$"),
                            _buildInfoRow("Actual", "${item.actual} K\$"),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(statusIcon, color: statusColor, size: 24),
                                const SizedBox(width: 10),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SfCartesianChart(
                          margin: const EdgeInsets.all(0), // Loại bỏ margin mặc định
                          plotAreaBorderWidth: 0, // Loại bỏ border
                          primaryXAxis: CategoryAxis(
                            labelPlacement: LabelPlacement.onTicks,
                            labelStyle: const TextStyle(fontSize: 14),
                          ),
                          primaryYAxis: NumericAxis(
                            labelStyle: const TextStyle(fontSize: 14),
                            minimum: 0,
                            maximum: item.actual > item.target
                                ? item.actual * 1.2
                                : item.target * 1.2,
                          ),
                          series: <CartesianSeries<TargetActualData, String>>[
                            BarSeries<TargetActualData, String>(
                              dataSource: [
                                TargetActualData('Actual', item.actual.toDouble()),
                                TargetActualData('Target', item.target.toDouble()),
                              ],
                              xValueMapper: (TargetActualData data, _) => data.label,
                              yValueMapper: (TargetActualData data, _) => data.value,
                              pointColorMapper: (TargetActualData data, _) =>
                              data.label == 'Actual'
                                  ? (item.actual > item.target
                                  ? Colors.red
                                  : item.actual == item.target
                                  ? Colors.green
                                  : Colors.green)
                                  : Colors.grey[400],
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(fontSize: 14),
                              ),
                              width: 0.4, // Giảm độ rộng cột
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dual Bar Chart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ReusableDualBarChart(data: getDualBarChartData),

          ],
        ),
      ),
    );
  }

}


  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text('$title:', style: TextStyle(fontSize: 18))),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
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

