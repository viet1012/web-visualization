import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../DetailScreen.dart';
import '../Model/DualBarData.dart';

class ReusableDualBarChart extends StatefulWidget {
  final List<DualBarData> data;

  const ReusableDualBarChart({super.key, required this.data});

  @override
  State<ReusableDualBarChart> createState() => _ReusableDualBarChartState();
}

class _ReusableDualBarChartState extends State<ReusableDualBarChart> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: 500,
              child: Stack(
                children: [
                  BarChart(
                    BarChartData(
                      maxY: _getMaxY(data),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.blueAccent,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final item = data[groupIndex];
                            String actualText = 'Actual: ${item.actual}';
                            String targetText = 'Target: ${item.target}';
                            String negativeText = '';

                            if (item.actual > item.target) {
                              double diff = item.actual - item.target;
                              negativeText = 'Negative: +${diff.toStringAsFixed(1)}';
                            }

                            return BarTooltipItem(
                              '$actualText\n$targetText${negativeText.isNotEmpty ? '\n$negativeText' : ''}',
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < data.length) {
                                final item = data[index];
                                final isSelected = selectedIndex == index;

                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(milliseconds: 400),
                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                                FadeTransition(opacity: animation, child: DetailScreen(item: item)),
                                          ),
                                        );
                                      },
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 300),
                                        style: TextStyle(
                                          fontSize: isSelected ? 18 : 16,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          color: isSelected ? Colors.blueAccent : Colors.black,
                                          decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
                                        ),
                                        child: Text(item.tiltle),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: _getInterval(data),
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              if (value % _getInterval(data) != 0) return Container();
                              String formattedValue = '${value.toInt()}';
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  formattedValue,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: _buildBarGroups(data),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  double _roundToNextMultiple(double value, double multiple) {
    return (value / multiple).ceil() * multiple;
  }

  double _getMaxY(List<DualBarData> data) {
    double maxVal = 0;
    double minVal = double.infinity;

    for (var item in data) {
      maxVal = [maxVal, item.actual, item.target].reduce((a, b) => a > b ? a : b);
      minVal = [minVal, item.actual, item.target].reduce((a, b) => a < b ? a : b);
    }

    return _roundToNextMultiple(maxVal + (maxVal - minVal) * 0.2, 10);
  }

  double _getInterval(List<DualBarData> data) {
    double maxVal = _getMaxY(data);
    double minVal = double.infinity;

    for (var item in data) {
      minVal = [minVal, item.actual, item.target].reduce((a, b) => a < b ? a : b);
    }

    double range = maxVal - minVal;
    double interval = range / 5;

    return _roundToNextMultiple(interval, 10);
  }

  List<BarChartGroupData> _buildBarGroups(List<DualBarData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      Color actualColor;
      if (item.actual > item.target) {
        actualColor = Colors.red;
      } else {
        actualColor = Colors.green;
      }

      return BarChartGroupData(
        x: index,
        barsSpace: 8,
        barRods: [
          BarChartRodData(
            toY: item.actual,
            color: actualColor,
            width: 20,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: item.target,
            color: Colors.grey,
            width: 20,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 20,
      children: [
        _legendItem(Colors.red, 'Actual > Target (Negative)'),
        _legendItem(Colors.green, 'Target Achieved'),
        _legendItem(Colors.grey, 'Target'),
        _legendItem(Colors.black, 'Unit: K\$'),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
      ],
    );
  }
}
