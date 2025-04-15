import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Detail/DetailScreen.dart';
import '../Model/DualBarData.dart';

class ReusableOverviewChart extends StatefulWidget {
  final List<DualBarData> data;

  const ReusableOverviewChart({super.key, required this.data});

  @override
  State<ReusableOverviewChart> createState() => _ReusableOverviewChartState();
}

class _ReusableOverviewChartState extends State<ReusableOverviewChart> {
  int? selectedIndex;

  //Data Demo
  List<DualBarData> _getDetailDataFor(DualBarData item) {
    return [
      DualBarData('A', item.actual - 10, item.target - 10),
      DualBarData('B', item.actual, item.target - 10),
      DualBarData('C', item.actual + 5, item.target - 10),
      DualBarData('D', item.actual - 2, item.target - 10),
      DualBarData('E', item.actual - 2, item.target - 10),
      DualBarData('F', item.actual - 2, item.target - 10),
      DualBarData('G', item.actual - 2, item.target - 10),
      DualBarData('H', item.actual - 4, item.target - 10),
      DualBarData('II', item.actual + 13, item.target - 10),
      DualBarData('JJ', item.actual - 20, item.target - 10),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .86,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(
                fontSize: 16,
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
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),
            primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                final detailData = _getDetailDataFor(item);
                setState(() {
                  selectedIndex = index;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => DetailScreen(item: item, detailData: detailData),
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
        width: 0.5,
        spacing: 0.05,
        // 👈 khoảng cách giữa các cột trong cùng nhóm
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 20, // 👈 Tùy chỉnh kích thước nếu cần
          ),
        ),
      ),
      ColumnSeries<DualBarData, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.tiltle,
        yValueMapper: (item, _) => item.target,
        name: 'Target',
        color: Colors.grey,
        width: 0.5,
        spacing: 0.05,
        // 👈 khoảng cách giữa các cột trong cùng nhóm
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 20, // 👈 Tùy chỉnh kích thước nếu cần
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
        Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
