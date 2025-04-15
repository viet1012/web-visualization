import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Common/ReusableDualBarChart.dart';
import 'MiniBarDetailChart.dart';
import 'OverviewDetailChart.dart';
import '../DualBarChart.dart';
import '../Model/DualBarData.dart';
import '../Model/TargetActualData.dart';

class DetailScreen extends StatelessWidget {
  final DualBarData item;

  const DetailScreen({super.key, required this.item});



  @override
  Widget build(BuildContext context) {

    List<DualBarData> getDualBarChartData=
    [
      DualBarData('A', 35, 43 ),  // Thực tế > Target => Âm
      DualBarData('B', 60, 49),  // Đạt
      DualBarData('C', 25, 35),  // Chưa đạt
      DualBarData('D', 40, 43),  // Đạt
      DualBarData('E', 42, 40),  // Âm
      DualBarData('F', 34, 55),  // Chưa đạt
      DualBarData('G', 35, 35),  // Chưa đạt
      DualBarData('H', 15, 35),  // Chưa đạt
      DualBarData('I', 35, 35),  // Chưa đạt
      DualBarData('J', 66, 35),  // Chưa đạt


    ];

    final status = _getStatus(item);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${item.tiltle} Detail'),
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
        backgroundColor: statusColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 10,
                shadowColor: statusColor,
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
                          child: MiniBarChart(
                            actual: item.actual.toDouble(),
                            target: item.target.toDouble(),
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
              OverviewDetailChart(data: getDualBarChartData),
          
            ],
          ),
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

