import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Model/TargetActualData.dart'; // hoặc sửa theo đường dẫn của bạn

class ToolCostDetailMiniBarChart extends StatelessWidget {
  final double actual;
  final double target;

  const ToolCostDetailMiniBarChart({
    super.key,
    required this.actual,
    required this.target,
  });
  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0.0");

    return SfCartesianChart(
      margin: const EdgeInsets.all(0),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.betweenTicks,
        labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        minimum: 0,
        maximum: actual > target ? actual * 1.2 : target * 1.2,

      ),
      series: <CartesianSeries<TargetActualData, String>>[
        BarSeries<TargetActualData, String>(
          dataSource: [
            TargetActualData('Actual', actual),
            TargetActualData('Target', target),
          ],
          dataLabelMapper: (item, _) => '${numberFormat.format(item.value)}K\$',
          xValueMapper: (data, _) => data.label,
          yValueMapper: (data, _) => data.value,
          pointColorMapper: (data, _) => data.label == 'Actual'
              ? (actual > target
              ? Colors.red
              : actual == target
              ? Colors.green
              : Colors.green)
              : Colors.grey[400],
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          width: 0.8,
        ),
      ],
    );
  }
}
