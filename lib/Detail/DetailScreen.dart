import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visualization/Model/ToolCostDetailModel.dart';
import '../Common/AnimatedShadowCard.dart';
import '../Common/CustomAppBar.dart';
import '../Common/DateDisplayWidget.dart';
import '../Common/TimeInfoCard.dart';
import '../Context/ToolCostContext.dart';
import '../Model/StackBarData.dart';
import '../Provider/ToolCostProvider.dart';
import 'ToolCostDetailMiniBarChart.dart';
import 'OverviewDetailChart.dart';
import '../Model/ToolCostModel.dart';

class DetailScreen extends StatefulWidget {
  final ToolCostModel item;
  // final String month;
  // final String dept;
  // final List<ToolCostDetailModel> detailData;
  final ToolCostDetailContext context;

  const DetailScreen({super.key, required this.item, required this.context});

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
              AnimatedShadowCard(
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
              OverviewDetailChart(context: widget.context),
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
