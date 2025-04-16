import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:visualization/ChartDataProvider.dart';

class DualBarChart extends StatefulWidget {
  @override
  State<DualBarChart> createState() => _DualBarChartState();
}

class _DualBarChartState extends State<DualBarChart> {
  int? selectedIndex;
  final data = ChartDataProvider.getDualBarChartData(); // Dữ liệu cột

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .85,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  BarChart(
                    BarChartData(
                      maxY: _getMaxY(),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.blueAccent, // Màu nền tooltip
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
                              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                        // touchResponseCallback: (touchResponse) {
                        //   // Callback cho touch, có thể thêm logic nếu cần
                        // },
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
                                    cursor: SystemMouseCursors.click, // 👈 Hiển thị pointer khi hover
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });

                                        // Chuyển trang với hiệu ứng fade
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: Duration(milliseconds: 400),
                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                                FadeTransition(opacity: animation, child: CircleAvatar()),
                                          ),
                                        );
                                      },
                                      child: AnimatedDefaultTextStyle(
                                        duration: Duration(milliseconds: 300),
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
                              return SizedBox.shrink();
                            },

                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: _getInterval(), // Sử dụng interval tính toán
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              if (value % _getInterval() != 0) return Container();

                              // Định dạng giá trị hiển thị cho trục Y
                              String formattedValue = '${value.toInt()}';

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  formattedValue,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: _buildBarGroups(),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                    ),

                  ),
                ],
              );
            }
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  // Hàm làm tròn lên đến số chẵn gần nhất
  double _roundToNextMultiple(double value, double multiple) {
    return (value / multiple).ceil() * multiple;
  }

// Tính toán maxY và interval sao cho chúng là bội số của 10
  double _getMaxY() {
    double maxVal = 0;
    double minVal = double.infinity;

    // Tìm max và min giữa actual và target
    for (var item in data) {
      maxVal = [maxVal, item.actual, item.target].reduce((a, b) => a > b ? a : b);
      minVal = [minVal, item.actual, item.target].reduce((a, b) => a < b ? a : b);
    }

    // Tính maxY, và làm tròn lên bội số của 10
    return _roundToNextMultiple(maxVal + (maxVal - minVal) * 0.2, 10);
  }

// Tính toán interval sao cho chúng là bội số của 10
  double _getInterval() {
    double maxVal = _getMaxY();
    double minVal = double.infinity;

    for (var item in data) {
      minVal = [minVal, item.actual, item.target].reduce((a, b) => a < b ? a : b);
    }

    // Tính interval sao cho giá trị hiển thị không quá dày đặc
    double range = maxVal - minVal;
    double interval = range / 5; // Chia thành 5 khoảng

    // Làm tròn interval lên bội số của 10
    return _roundToNextMultiple(interval, 10);
  }

  List<BarChartGroupData> _buildBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      Color actualColor;
      if (item.actual > item.target) {
        actualColor = Colors.red;
      } else if (item.actual == item.target) {
        actualColor = Colors.green;
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
            width: 40,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: item.target,
            color: Colors.grey,
            width: 40,
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
        _legendItem(Colors.black, 'Unit: K\$'), // Chú thích đơn vị K$
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, color: color),
        SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
      ],
    );
  }
}
