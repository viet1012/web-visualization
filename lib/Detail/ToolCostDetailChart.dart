import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../API/ApiService.dart';
import '../Common/NoDataWidget.dart';
import '../Common/ToolCostPopup.dart';
import '../Context/ToolCostContext.dart';
import '../Model/DetailsDataModel.dart';
import '../Model/ToolCostDetailModel.dart';
import '../Model/ToolCostModel.dart';
import '../SubDetail/ToolCostSubDetailScreen.dart';

class ToolCostDetailChart extends StatefulWidget {
  final ToolCostModel toolCost;
  final List<ToolCostDetailModel> data;
  final String month;
  final String dept;
  const ToolCostDetailChart({
    super.key,
    required this.toolCost,
    required this.data,
    required this.dept,
    required this.month,
  });

  @override
  State<ToolCostDetailChart> createState() => _ToolCostDetailChartState();
}

class _ToolCostDetailChartState extends State<ToolCostDetailChart> {
  int? selectedIndex;

  final numberFormat = NumberFormat("##0.0");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .66,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 0),
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
              majorGridLines: const MajorGridLines(width: 0),
              minorGridLines: const MinorGridLines(width: 0),
              title: AxisTitle(
                text: 'K\$',
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            onAxisLabelTapped: (AxisLabelTapArgs args) {
              final index = widget.data.indexWhere((e) => e.title == args.text);
              if (index != -1) {
                final item = widget.data[index];
                setState(() {
                  selectedIndex = index;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ToolCostSubDetailScreen(item: widget.toolCost, detail: item, month: widget.month,),
                  ),
                );
              }
            },
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: '',
              canShowMarker: true,
              textStyle: TextStyle(
                fontSize: 20,
              ),
            ),
            series: _buildSeries(widget.data),

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
    return <CartesianSeries<ToolCostDetailModel, String>>[
      AreaSeries<ToolCostDetailModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.target_ORG,
        dataLabelMapper: (item, _) => numberFormat.format(item.target_ORG),
        name: 'Target ORG',
        gradient: LinearGradient(
          colors: [Colors.grey.withOpacity(0.2), Colors.grey.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: Colors.grey.withOpacity(.5),
        borderWidth: 2,
        dataLabelSettings: const DataLabelSettings(
          labelAlignment: ChartDataLabelAlignment.top,
          isVisible: false,
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      AreaSeries<ToolCostDetailModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.target_Adjust,
        dataLabelMapper: (item, _) => numberFormat.format(item.target_Adjust),
        name: 'Target Adjust',
        gradient: LinearGradient(
          colors: [Colors.orange.withOpacity(0.1), Colors.orange.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: Colors.orange.withOpacity(0.5),
        borderWidth: 2,
        dataLabelSettings:  DataLabelSettings(
          labelAlignment: ChartDataLabelAlignment.top,
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.orange.withOpacity(0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ColumnSeries<ToolCostDetailModel, String>(
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.actual,
        dataLabelMapper: (item, _) => numberFormat.format(item.actual),
        pointColorMapper:
            (item, _) => item.actual > item.target_Adjust ? Colors.red : Colors.green,
        name: 'Actual',
        width: 0.5,
        spacing: 0.2,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
          textStyle: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
                .fetchSubDetailsData(widget.month,  widget.dept ,item.title);

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
      // 👉 Miền Target màu xám

      // 👉 Cột Actual màu xanh nếu đạt, màu đỏ nếu vượt target
    ];
  }


  double _getInterval(List<ToolCostDetailModel> data) {
    double maxVal = data
        .map((e) => e.actual > e.target_ORG ? e.actual : e.target_ORG)
        .reduce((a, b) => a > b ? a : b);
    return (maxVal / 5).ceilToDouble();
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 20,
      children: [
        _legendItem(Colors.red, 'Actual > Target (Negative)'),
        _legendItem(Colors.green, 'Target Achieved'),
        _legendItem(Colors.grey, 'Target_Org'),
        _legendItem(Colors.orange.withOpacity(.5), 'Target_Adjust'),
      ],
    );
  }

  Widget _legendItem(Color color, String text, {bool dashed = false}) {
    final box = dashed
        ? DottedBorder(
      color: color,
      strokeWidth: 2,
      dashPattern: [4, 3],
      borderType: BorderType.RRect,
      radius: const Radius.circular(2),
      child: SizedBox(width: 16, height: 16),
    )
        : Container(width: 16, height: 16, color: color);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        box,
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

}
