import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visualization/API/ApiService.dart';
import '../Common/ToolCostPopup.dart';
import '../Common/ToolCostStatusHelper.dart';
import '../Model/DetailsDataModel.dart';
import '../Model/ToolCostModel.dart';
import 'dart:html' as html;
import 'package:dotted_border/dotted_border.dart';

class ToolCostOverviewChart extends StatefulWidget {
  final List<ToolCostModel> data;
  final String month;

  const ToolCostOverviewChart({
    super.key,
    required this.data,
    required this.month,
  });

  @override
  State<ToolCostOverviewChart> createState() => _ToolCostOverviewChartState();
}

class _ToolCostOverviewChartState extends State<ToolCostOverviewChart> {
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
          // height: MediaQuery.of(context).size.height * .38,
          height: MediaQuery.of(context).size.height * .85,

          child: SfCartesianChart(
            plotAreaBorderColor: Colors.black45,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 0),
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
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(width: 0),
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

                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('View information'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tuỳ chọn 1
                          ListTile(
                            leading: const Icon(Icons.info, color: Colors.blue),
                            title: Text(
                              '${item.title} by Group',
                              style: TextStyle(fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              // Xử lý khi chọn ô này (VD: mở chi tiết)
                              context.go(
                                '/by-group/${item.title.toUpperCase()}?month=${widget.month}',
                              );
                            },
                          ),
                          const Divider(),
                          // Tuỳ chọn 2
                          ListTile(
                            leading: const Icon(Icons.info, color: Colors.blue),
                            title: Text(
                              '${item.title} by Day',
                              style: TextStyle(fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              // Xử lý khi chọn ô này (VD: mở chi tiết)
                              context.go(
                                '/by-day/${item.title.toUpperCase()}?month=${widget.month}',
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },

            // onAxisLabelTapped: (AxisLabelTapArgs args) async {
            //   final index = widget.data.indexWhere((e) => e.title == args.text);
            //   if (index != -1) {
            //     final item = widget.data[index];
            //
            //     // Hiển thị dialog loading
            //     showDialog(
            //       context: context,
            //       barrierDismissible: false,
            //       builder:
            //           (_) => const Center(child: CircularProgressIndicator()),
            //     );
            //
            //     try {
            //
            //       // Tắt dialog loading
            //       Navigator.of(context).pop();
            //
            //       print('Navigating to /${item.title}/${widget.month}');
            //       context.go('/${item.title}?month=${widget.month}');
            //
            //       // redirectToPage(item.title);
            //     } catch (e) {
            //       // Nếu có lỗi, tắt dialog và show error
            //       Navigator.of(context).pop();
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text("Lỗi khi load dữ liệu: $e")),
            //       );
            //     }
            //   }
            // },
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: '',
              canShowMarker: true,
              builder: (
                dynamic data,
                dynamic point,
                dynamic series,
                int pointIndex,
                int seriesIndex,
              ) {
                final item = data as ToolCostModel;
                final status = ToolCostStatusHelper.getStatus(item);
                final statusColor = ToolCostStatusHelper.getStatusColor(status);

                if (series.name == 'Thừa ORG') {
                  // 👉 Nếu là series "TGT_Adjust" thì custom
                  return DottedBorder(
                    color: Colors.grey.shade700,
                    strokeWidth: 3,
                    dashPattern: [5, 5],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(2),
                    child: Container(
                      color: Colors.black,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Target_Org: ${numberFormat.format(item.target_ORG)}',
                        // 👈 hiện target_ORG
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                if (series.name == 'Actual') {
                  // 👉 Nếu là series "TGT_Adjust" thì custom
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        width: 2, // Độ dày của border
                      ),
                    ),
                    child: Text(
                      'Actual: ${numberFormat.format(item.actual)}',
                      // 👈 hiện target_ORG
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  );
                }
                if (series.name == 'Thiếu ORG') {
                  // 👉 Nếu là series "TGT_Adjust" thì custom
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        width: 2, // Độ dày của border
                      ),
                    ),
                    child: Text(
                      'Target_Adjust: ${numberFormat.format(item.target_Adjust)}', // 👈 hiện target_ORG
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  );
                } else {
                  if (item.target_ORG > item.target_Adjust) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          width: 2, // Độ dày của border
                        ),
                      ),
                      child: Text(
                        'Target_Adjust: ${numberFormat.format(point.y)}',
                        // 👈 hiện y value bình thường
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return DottedBorder(
                      color: Colors.grey.shade700,
                      strokeWidth: 3,
                      dashPattern: [5, 5],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(2),
                      child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          item.target_ORG > item.target_Adjust
                              ? 'Target_Adjust: ${numberFormat.format(point.y)}'
                              : 'Target_Org: ${numberFormat.format(point.y)}',
                          // 👈 hiện y value bình thường
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
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
        animationDuration: 500,
        // 👈 Tắt animation
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.actual,
        dataLabelMapper: (item, _) => numberFormat.format(item.actual),
        pointColorMapper:
            (item, _) =>
                item.actual > item.target_Adjust ? Colors.red : Colors.green,
        name: 'Actual',
        width: 0.5,
        spacing: 0.1,
        // 👈 khoảng cách giữa các cột trong cùng nhóm
        dataLabelSettings: const DataLabelSettings(
          labelAlignment: ChartDataLabelAlignment.top,
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 20, // 👈 Tùy chỉnh kích thước nếu cần
            fontWeight: FontWeight.w600,
            color: Colors.white,
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

      // / / // / / / / / / / / // // / // // / / / / // / /  / / / / / // / / / / / /
      StackedColumnSeries<ToolCostModel, String>(
        animationDuration: 500,
        // 👈 Tắt animation
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper:
            (item, _) =>
                (item.target_Adjust < item.target_ORG)
                    ? item.target_Adjust
                    : item.target_ORG,
        dataLabelMapper: (item, _) => numberFormat.format(item.target_Adjust),
        name: 'TGT_Adjust',
        color: Colors.grey,
        width: 0.5,
        spacing: 0.2,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),

      StackedColumnSeries<ToolCostModel, String>(
        animationDuration: 500,
        // 👈 Tắt animation
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper: (item, _) => item.orgMinusAdjust,
        name: 'Thừa ORG',
        color: Colors.transparent,
        borderColor: Colors.grey.shade700,
        borderWidth: 2,
        dashArray: [5, 5],
        width: 0.5,
        spacing: 0.2,
        dataLabelSettings: const DataLabelSettings(isVisible: false),
      ),

      StackedColumnSeries<ToolCostModel, String>(
        animationDuration: 500,
        // 👈 Tắt animation
        dataSource: data,
        xValueMapper: (item, _) => item.title,
        yValueMapper:
            (item, _) =>
                (item.target_Adjust > item.target_ORG)
                    ? item.adjustMinusOrg
                    : 0,
        name: 'Thiếu ORG',

        color: Colors.grey,
        borderWidth: 4,
        width: 0.5,
        spacing: 0.2,
        dataLabelSettings: const DataLabelSettings(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ];
  }

  double _getInterval(List<ToolCostModel> data) {
    if (data.isEmpty) return 1;

    double maxVal = data
        .map((e) => e.actual > e.target_ORG ? e.actual : e.target_ORG)
        .reduce((a, b) => a > b ? a : b);

    // Tránh chia ra 0
    final interval = (maxVal / 5).ceilToDouble();
    return interval > 0 ? interval : 1;
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
            (item, _) =>
                item.actual > item.target_ORG ? Colors.red : Colors.green,
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
            (item, _) =>
                (item.target_ORG - item.actual).clamp(0, double.infinity),
        dataLabelMapper: (item, _) => numberFormat.format(item.target_ORG),
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
        _legendItem(Colors.grey, 'Target_Adjust'),
        _legendItem(Colors.grey, 'Target_Org', dashed: true),
      ],
    );
  }

  Widget _legendItem(Color color, String text, {bool dashed = false}) {
    final box =
        dashed
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
