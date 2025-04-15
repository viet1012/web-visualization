import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'Model/DualBarData.dart';

class ChartDataProvider {

  static List<DualBarData> getDualBarChartData() {
    return [
      DualBarData('PR_PRO', 80, 120 ),
      DualBarData('MO_PRO', 120, 100),
      DualBarData('GU_PRO', 150, 60),
      DualBarData('MA', 100, 100),
      DualBarData('TE', 134, 120),
      DualBarData('COMMON', 130, 130),
    ];
  }

  static List<PieChartSectionData> getPieChartDataFromDualBarData() {
    final data = getDualBarChartData(); // Dữ liệu cột

    int negativeCount = 0;
    int achievedCount = 0;
    int notAchievedCount = 0;

    for (var item in data) {
      if (item.actual > item.target) {
        negativeCount++;
      } else if (item.actual == item.target) {
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