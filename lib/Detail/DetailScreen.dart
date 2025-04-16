import 'package:flutter/material.dart';
import '../Common/CustomAppBar.dart';
import '../Common/DateDisplayWidget.dart';
import '../Common/TimeInfoCard.dart';
import 'MiniBarDetailChart.dart';
import 'OverviewDetailChart.dart';
import '../Model/DualBarData.dart';

class DetailScreen extends StatelessWidget {
  final DualBarData item;
  final List<DualBarData> detailData;

  const DetailScreen({super.key, required this.item, required this.detailData});

  @override
  Widget build(BuildContext context) {
    final status = _getStatus(item);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Scaffold(
      appBar: CustomAppBar(
        titleText: '${item.tiltle} ',
        finalTime: "12:00 PM",
        nextTime: "03:00 PM",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 10,
                shadowColor: statusColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width:
                              MediaQuery.of(context).size.width *
                              0.1, // Chiếm 10% chiều rộng
                          padding: const EdgeInsets.all(16),
                          child: Row(
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
                        ),
                        SizedBox(
                          height: 150,
                          width: MediaQuery.of(context).size.width * .7,
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
              OverviewDetailChart(data: detailData),
            ],
          ),
        ),
      ),
    );
  }
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
