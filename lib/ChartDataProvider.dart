import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'Model/ToolCostModel.dart';

class ChartDataProvider {

  static List<ToolCostModel> getDualBarChartData() {
    return [
      // ToolCostModel('PR_PRO', 80, 120, DateTime(2025, 4, 1)),
      // ToolCostModel('MO_PRO', 120, 100, DateTime(2025, 4, 1)),
      // ToolCostModel('GU_PRO', 150, 60, DateTime(2025, 4, 1)),
      // ToolCostModel('MA', 100, 100, DateTime(2025, 4, 1)),
      // ToolCostModel('TE', 134, 120, DateTime(2025, 4, 1)),
      // ToolCostModel('COMMON', 130, 130, DateTime(2025, 3, 1)),
      // ToolCostModel('PR_PRO', 200, 200, DateTime(2025, 3, 1)),
      // ToolCostModel('MO_PRO', 220, 200, DateTime(2025, 3, 1)),
      // ToolCostModel('GU_PRO', 150, 200, DateTime(2025, 3, 1)),
      // ToolCostModel('MA', 100, 200, DateTime(2025, 3, 3)),
      // ToolCostModel('TE', 134, 200, DateTime(2025, 3, 1)),
    ];
  }


  static List<PieChartSectionData> getPieChartDataFromDualBarData() {
    final data = getDualBarChartData(); // Dữ liệu cột

    int negativeCount = 0;
    int achievedCount = 0;
    int notAchievedCount = 0;

    for (var item in data) {
      if (item.actual > item.target_ORG) {
        negativeCount++;
      } else if (item.actual == item.target_ORG) {
        achievedCount++;
      } else {
        notAchievedCount++;
      }
    }

    int total = data.length;

    return [
      PieChartSectionData(
        color: Colors.red,
        value: (negativeCount / total) * 100,
        title: '${((negativeCount / total) * 100).toStringAsFixed(1)}%',
        radius: 100,
        showTitle: true,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: Text('Over Target', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        badgePositionPercentageOffset: 1.5,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: (achievedCount / total) * 100,
        title: '${((achievedCount / total) * 100).toStringAsFixed(1)}%',
        radius: 100,
        showTitle: true,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: Text('Target Met', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        badgePositionPercentageOffset: 1.5,
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: (notAchievedCount / total) * 100,
        title: '${((notAchievedCount / total) * 100).toStringAsFixed(1)}%',
        radius: 100,
        showTitle: true,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: Text('Below Target', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        badgePositionPercentageOffset: 1.5,
      ),
    ];
  }


}