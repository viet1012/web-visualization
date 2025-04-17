import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visualization/Model/ToolCostDetailModel.dart';
import '../Common/CustomAppBar.dart';
import '../Common/DateDisplayWidget.dart';
import '../Common/TimeInfoCard.dart';
import '../Model/StackBarData.dart';
import '../Provider/ToolCostProvider.dart';
import 'MiniBarDetailChart.dart';
import 'OverviewDetailChart.dart';
import '../Model/ToolCostModel.dart';

class DetailScreen extends StatefulWidget {
  final ToolCostModel item;
  final List<ToolCostDetailModel> detailData;

  const DetailScreen({super.key, required this.item, required this.detailData});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {

    final selectedItem = Provider.of<ToolCostProvider>(context).selectedItem;

    final status = _getStatus(widget.item);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Scaffold(
      appBar: CustomAppBar(
        titleText: '${selectedItem?.title.toString()} ',
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .1,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                          width: MediaQuery.of(context).size.width * .8,
                          child: MiniBarChart(
                            actual: selectedItem!.actual.toDouble(),
                            target: selectedItem.target.toDouble(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tools Cost By Each Groups',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              OverviewDetailChart(data: widget.detailData),
            ],
          ),
        ),
      ),
    );
  }
}

String _getStatus(ToolCostModel item) {
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
