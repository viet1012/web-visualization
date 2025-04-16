import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../SubDetail/SubDetailScreen.dart';
import '../Model/DualBarData.dart';

class OverviewDetailChart extends StatefulWidget {
  final List<DualBarData> data;

  const OverviewDetailChart({super.key, required this.data});

  @override
  State<OverviewDetailChart> createState() => _OverviewDetailChartState();
}

class _OverviewDetailChartState extends State<OverviewDetailChart> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                final index = int.tryParse(details.text);
                if (index != null && index < widget.data.length) {
                  final isSelected = selectedIndex == index;
                  return ChartAxisLabel(
                    widget.data[index].tiltle,
                    TextStyle(
                      color: isSelected ? Colors.blueAccent : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      decoration:
                          isSelected
                              ? TextDecoration.underline
                              : TextDecoration.none,
                      fontSize: isSelected ? 16 : 14,
                    ),
                  );
                }
                return ChartAxisLabel(
                  details.text,
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              },
            ),
            primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(fontSize: 18),
              interval: _getInterval(widget.data),
              title: AxisTitle(
                text: 'K\$',
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            series: _buildSeries(widget.data),
            onAxisLabelTapped: (AxisLabelTapArgs args) {
              final index = widget.data.indexWhere(
                (e) => e.tiltle == args.text,
              );
              if (index != -1) {
                final item = widget.data[index];
                setState(() {
                  selectedIndex = index;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubDetailScreen(item: item),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  List<CartesianSeries<DualBarData, String>> _buildSeries(
    List<DualBarData> data,
  ) {
    return <CartesianSeries<DualBarData, String>>[
      ColumnSeries<DualBarData, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.tiltle,
        yValueMapper: (item, _) => item.actual,
        pointColorMapper:
            (item, _) => item.actual > item.target ? Colors.red : Colors.green,
        name: 'Actual',
        width: 0.6,
        spacing: 0.1,
        // 👈 khoảng cách giữa các cột trong cùng nhóm
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 18, // 👈 Tùy chỉnh kích thước nếu cần
          ),
        ),
      ),
      ColumnSeries<DualBarData, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.tiltle,
        yValueMapper: (item, _) => item.target,
        name: 'Target',
        color: Colors.grey,
        width: 0.6,
        spacing: 0.1,
        // 👈 khoảng cách giữa các cột trong cùng nhóm
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 18, // 👈 Tùy chỉnh kích thước nếu cần
          ),
        ),
      ),
    ];
  }

  double _getInterval(List<DualBarData> data) {
    double maxVal = data
        .map((e) => e.actual > e.target ? e.actual : e.target)
        .reduce((a, b) => a > b ? a : b);
    return (maxVal / 5).ceilToDouble();
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 20,
      children: [
        _legendItem(Colors.red, 'Actual > Target (Negative)'),
        _legendItem(Colors.green, 'Target Achieved'),
        _legendItem(Colors.grey, 'Target'),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
