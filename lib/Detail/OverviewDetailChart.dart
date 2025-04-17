import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visualization/Model/ToolCostDetailModel.dart';

import '../Common/NoDataWidget.dart';
import '../SubDetail/SubDetailScreen.dart';
import '../Model/ToolCostModel.dart';

class OverviewDetailChart extends StatefulWidget {
  final List<ToolCostDetailModel> data;

  const OverviewDetailChart({super.key, required this.data});

  @override
  State<OverviewDetailChart> createState() => _OverviewDetailChartState();
}

class _OverviewDetailChartState extends State<OverviewDetailChart> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {

    if (widget.data.isEmpty) {
      return const NoDataWidget(
        title: "No Data Available",
        message: "Please try again with a different time range.",
        icon: Icons.error_outline,
      );
    }

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
                    widget.data[index].title,
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
                (e) => e.title == args.text,
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




  List<CartesianSeries<ToolCostDetailModel, String>> _buildSeries(
      List<ToolCostDetailModel> data,
      ) {

    final greenData = data.where((e) => e.actual <= e.target).toList();
    final redData = data.where((e) => e.actual > e.target).toList();

    return <CartesianSeries<ToolCostDetailModel, String>>[
      // 👉 Miền Target màu xám
      AreaSeries<ToolCostDetailModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.target,
        name: 'Target',
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.5),
            Colors.grey.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: Colors.grey,
        borderWidth: 2,

        dataLabelSettings: const DataLabelSettings(
          labelAlignment: ChartDataLabelAlignment.top,
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // 👉 Cột Actual màu xanh nếu đạt, màu đỏ nếu vượt target
      StackedColumnSeries<ToolCostDetailModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.actual,
        pointColorMapper: (item, _) =>
        item.actual > item.target ? Colors.red : Colors.green,
        name: 'Actual',
        width: 0.5,
        spacing: 0.2,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }


  List<CartesianSeries<ToolCostDetailModel, String>> _buildSeries1(
    List<ToolCostDetailModel> data,
  ) {
    return <CartesianSeries<ToolCostDetailModel, String>>[
      ColumnSeries<ToolCostDetailModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.actual,
        pointColorMapper:
            (item, _) => item.actual > item.target ? Colors.red : Colors.green,
        name: 'Actual',
        width: 0.6,
        spacing: 0.2,
        // 👈 khoảng cách giữa các cột trong cùng nhóm
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 18, // 👈 Tùy chỉnh kích thước nếu cần
          ),
        ),
      ),
      ColumnSeries<ToolCostDetailModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.target,
        name: 'Target',
        color: Colors.grey,
        width: 0.6,
        spacing: 0.2,

        // 👈 khoảng cách giữa các cột trong cùng nhóm
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 16, // 👈 Tùy chỉnh kích thước nếu cần
          ),
        ),
      ),
    ];
  }

  double _getInterval(List<ToolCostDetailModel> data) {
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
