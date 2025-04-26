import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Common/AnimatedShadowCard.dart';
import '../Common/CustomAppBar.dart';
import '../Common/DateDisplayWidget.dart';
import '../Common/TimeInfoCard.dart';
import '../Common/ToolCostStatusHelper.dart';
import '../Context/ToolCostContext.dart';
import '../Model/ToolCostDetailModel.dart';
import 'ToolCostDetailMiniBarChart.dart';
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
    final status = ToolCostStatusHelper.getStatus(widget.toolCostModel);
    final statusColor = ToolCostStatusHelper.getStatusColor(status);
    final statusIcon = ToolCostStatusHelper.getStatusIcon(status);

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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                            SizedBox(height: 8),
                            if (widget.toolCostModel.actual >
                                widget.toolCostModel.target_Adjust)
                              Row(
                                children: [
                                  Text(
                                    'Exceeded by ',
                                    style:  TextStyle(
                                      color: Colors.red.withOpacity(0.6),
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat("#,##0.0").format(widget.toolCostModel.actual - widget.toolCostModel.target_Adjust)}K\$',
                                    style:  TextStyle(
                                      color: Colors.red.withOpacity(0.8),
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width * .8,
                        child: ToolCostDetailMiniBarChart(
                          actual: widget.toolCostModel.actual.toDouble(),
                          target: widget.toolCostModel.target_Adjust.toDouble(),
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
          ToolCostDetailChart(
            toolCost: widget.toolCostModel,
            data: widget.data,
            dept: widget.toolCostModel.title,
            month: widget.month,
          ),
        ],
      ),
    );
  }
}
