import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visualization/API/ApiService.dart';

import '../Common/ToolCostPopup.dart';
import '../Context/ToolCostContext.dart';
import '../Detail/DetailScreen.dart';
import '../Detail/ToolCostDetail.dart';
import '../Model/DetailsDataModel.dart';
import '../Model/ToolCostModel.dart';
import '../Provider/ToolCostProvider.dart';

class ReusableOverviewChart extends StatefulWidget {
  final List<ToolCostModel> data;
  final String month;

  const ReusableOverviewChart({
    super.key,
    required this.data,
    required this.month,
  });

  @override
  State<ReusableOverviewChart> createState() => _ReusableOverviewChartState();
}

class _ReusableOverviewChartState extends State<ReusableOverviewChart> {
  int? selectedIndex;
  final apiService = ApiService();
  final numberFormat = NumberFormat("##0.0");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Tools Cost",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .85,
          child: SfCartesianChart(
            plotAreaBorderColor: Colors.black45,
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
            onAxisLabelTapped: (AxisLabelTapArgs args) async {
              final index = widget.data.indexWhere((e) => e.title == args.text);
              if (index != -1) {
                final item = widget.data[index];

                // Hiển thị dialog loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (_) => const Center(child: CircularProgressIndicator()),
                );

                try {
                  final detailData = await apiService.fetchToolCostsDetail(
                    widget.month,
                    item.title,
                  );
                  Provider.of<ToolCostProvider>(
                    context,
                    listen: false,
                  ).setSelectedItem(item);

                  setState(() {
                    selectedIndex = index;
                  });

                  // Tắt dialog loading
                  Navigator.of(context).pop();

                  var toolCostContext = ToolCostContext(month: widget.month, dept:item.title , data: detailData);
                  // Navigate sang màn hình chi tiết
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              DetailScreen(item: item, context: toolCostContext,),
                    ),
                  );
                } catch (e) {
                  // Nếu có lỗi, tắt dialog và show error
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi khi load dữ liệu: $e")),
                  );
                }
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildLegend(),
      ],
    );
  }

  List<CartesianSeries<ToolCostModel, String>> _buildSeries(
    List<ToolCostModel> data,
  ) {
    return <CartesianSeries<ToolCostModel, String>>[
      ColumnSeries<ToolCostModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.actual,
        dataLabelMapper: (item, _) => numberFormat.format(item.actual),
        pointColorMapper:
            (item, _) => item.actual > item.target ? Colors.red : Colors.green,
        name: 'Actual',
        width: 0.5,
        spacing: 0.1,
        // 👈 khoảng cách giữa các cột trong cùng nhóm
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 20, // 👈 Tùy chỉnh kích thước nếu cần
            fontWeight: FontWeight.w600,
          ),
        ),

        onPointTap: (ChartPointDetails details) async {
          final index = details.pointIndex ?? -1;
          final item = widget.data[index];

          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          try {
            // Gọi API để lấy dữ liệu
            List<DetailsDataModel> detailsData = await ApiService()
                .fetchDetailsData(widget.month, item.title);

            // Tắt loading
            Navigator.of(context).pop();

            if (detailsData.isNotEmpty) {
              // Hiển thị popup dữ liệu
              showDialog(
                context: context,
                builder:
                    (_) =>
                        ToolCostPopup(title: 'Details Data', data: detailsData),
              );
            } else {
              // Có thể thêm thông báo nếu không có dữ liệu
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        fontSize: 22.0, // Tăng kích thước font chữ
                        fontWeight: FontWeight.bold, // Tùy chọn để làm đậm
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  // Thêm khoảng cách trên/dưới
                  behavior:
                      SnackBarBehavior
                          .fixed, // Tùy chọn hiển thị phía trên thay vì ở dưới
                ),
              );
            }
          } catch (e) {
            Navigator.of(context).pop(); // Đảm bảo tắt loading nếu lỗi
            print("Error fetching data: $e");
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error fetching data')));
          }
        },
      ),
      ColumnSeries<ToolCostModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.target,
        dataLabelMapper: (item, _) => numberFormat.format(item.target),
        name: 'Target',
        color: Colors.grey,
        width: 0.5,
        spacing: 0.1,
        // 👈 khoảng cách giữa các cột trong cùng nhóm
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 20, // 👈 Tùy chỉnh kích thước nếu cần
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ];
  }

  double _getInterval(List<ToolCostModel> data) {
    double maxVal = data
        .map((e) => e.actual > e.target ? e.actual : e.target)
        .reduce((a, b) => a > b ? a : b);
    return (maxVal / 5).ceilToDouble();
  }

  List<CartesianSeries<ToolCostModel, String>> _buildSeries1(
    List<ToolCostModel> data,
  ) {
    return <CartesianSeries<ToolCostModel, String>>[
      StackedColumnSeries<ToolCostModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.actual,
        dataLabelMapper: (item, _) => numberFormat.format(item.actual),
        pointColorMapper:
            (item, _) => item.actual > item.target ? Colors.red : Colors.green,
        name: 'Actual',
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      StackedColumnSeries<ToolCostModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        // Target - Actual để hiển thị phần còn thiếu trong cột
        yValueMapper:
            (item, _) => (item.target - item.actual).clamp(0, double.infinity),
        dataLabelMapper: (item, _) => numberFormat.format(item.target),
        name: 'Remaining to Target',
        color: Colors.grey,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    ];
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
