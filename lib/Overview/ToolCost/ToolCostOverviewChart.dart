import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visualization/API/ApiService.dart';

import '../../Common/ToolCostPopup.dart';
import '../../Common/ToolCostStatusHelper.dart';
import '../../Model/DetailsDataModel.dart';
import '../../Model/ToolCostModel.dart';

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
          height: MediaQuery.of(context).size.height * .8,
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
                return ChartAxisLabel(
                  details.text,
                  TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 3,
                  ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text(
                        'View Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade50,
                              child: const Icon(
                                Icons.grid_view,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(
                              '${item.title} by Group',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: const Text(
                              'View data summarized by group',
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              context.go(
                                '/by-group/${item.title.toUpperCase()}?month=${widget.month}',
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade50,
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(
                              '${item.title} by Day',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: const Text(
                              'View daily breakdown of data',
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
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
                if (series.name == 'Actual') {
                  final percent =
                      item.target_Adjust > 0
                          ? (item.actual / item.target_Adjust) * 100
                          : 0;

                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actual: ${numberFormat.format(item.actual)}K\$',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Rate: ${percent.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '👇 Click the bar to see details',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }

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
                        'Target_Org: ${numberFormat.format(item.target_ORG)}K\$',
                        // 👈 hiện target_ORG
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
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
                      'Target_Adjust: ${numberFormat.format(item.target_Adjust)}K\$', // 👈 hiện target_ORG
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
                        'Target_Adjust: ${numberFormat.format(point.y)}K\$',
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
                              ? 'Target_Adjust: ${numberFormat.format(point.y)}K\$'
                              : 'Target_Org: ${numberFormat.format(point.y)}K\$',
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
                    (_) => ToolCostPopup(
                      title: 'Details Data',
                      data: detailsData,
                      totalActual: item.title == "PE" ? 0 : item.actual,
                      group: item.title,
                    ),
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
