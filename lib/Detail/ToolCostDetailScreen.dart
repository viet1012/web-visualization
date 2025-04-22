import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Common/AnimatedShadowCard.dart';
import '../Common/CustomAppBar.dart';
import '../Common/DateDisplayWidget.dart';
import '../Common/TimeInfoCard.dart';
import '../Context/ToolCostContext.dart';
import '../Model/StackBarData.dart';
import '../Model/ToolCostDetailModel.dart';
import 'ToolCostDetailMiniBarChart.dart';
import 'OverviewDetailChart.dart';
import '../Model/ToolCostModel.dart';
import 'ToolCostDetailChart.dart';

class ToolCostDetailScreen extends StatefulWidget {
  final ToolCostModel toolCostModel;
  final List<ToolCostDetailModel> data;
  final String month;
  const ToolCostDetailScreen({
    super.key,
    required this.data,
    required this.month,
    required this.toolCostModel,
  });

  @override
  State<ToolCostDetailScreen> createState() => _ToolCostDetailScreenState();
}

class _ToolCostDetailScreenState extends State<ToolCostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final status = _getStatus(widget.toolCostModel);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .15,
            child: AnimatedShadowCard(
              glowColor: statusColor,
              elevation: 10,
              borderRadius: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .13,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, color: statusColor, size: 30),
                            const SizedBox(width: 10),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 20,
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
                        child: ToolCostDetailMiniBarChart(
                          actual: widget.toolCostModel.actual.toDouble(),
                          target: widget.toolCostModel.target.toDouble(),
                        ),
                      ),
                    ],
                  ),
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
          ToolCostDetailChart(data: widget.data, dept: widget.toolCostModel.title ,month: widget.month),
        ],
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
