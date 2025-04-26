import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visualization/Model/ToolCostDetailModel.dart';
import 'package:visualization/Model/ToolCostSubDetailModel.dart';
import '../API/ApiService.dart';
import '../Common/CustomAppBar.dart';
import '../Common/CustomToolCostAppBar.dart';
import '../Common/NoDataWidget.dart';
import '../Common/ToolCostPopup.dart';
import '../Common/ToolCostStatusHelper.dart';
import '../Model/DetailsDataModel.dart';
import '../Model/ToolCostModel.dart';
import '../Provider/ToolCostProvider.dart';

class ToolCostSubDetailScreen extends StatefulWidget {
  final ToolCostModel item;
  final ToolCostDetailModel detail;
  final String month;

  const ToolCostSubDetailScreen({
    super.key,
    required this.item,
    required this.detail,
    required this.month,
  });

  @override
  State<ToolCostSubDetailScreen> createState() =>
      _ToolCostSubDetailScreenState();
}

class _ToolCostSubDetailScreenState extends State<ToolCostSubDetailScreen> {
  List<ToolCostSubDetailModel> monthlyData = [];
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  final numberFormat = NumberFormat("##0.0");

  @override
  void initState() {
    super.initState();
    _loadDetailData();
  }

  bool isLoading = true;

  Future<void> _loadDetailData() async {
    setState(() {
      isLoading = true;
    });

    final month = DateFormat('yyyy-MM').format(selectedDate);

    List<ToolCostSubDetailModel> detailsData = await ApiService()
        .fetchToolCostsSubDetail(month, widget.item.title, widget.detail.title);

    setState(() {
      monthlyData = detailsData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ToolCostProvider>(); // 👈 lấy dữ liệu từ Provider

    final status = ToolCostStatusHelper.getStatus(widget.item);
    final statusColor = ToolCostStatusHelper.getStatusColor(status);
    final statusIcon = ToolCostStatusHelper.getStatusIcon(status);


    return Scaffold(
      appBar: CustomToolCostAppBar(
        titleText: '${widget.detail.title} ',
        selectedDate: selectedDate,

        onDateChanged: (newDate) async {
          setState(() {
            selectedDate = newDate;
            selectedMonth = newDate.month;
            selectedYear = newDate.year;
          });

          await _loadDetailData();
        },

        currentDate: provider.lastFetchedDate,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.blue.shade100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Target vs Actual (by day)',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(statusIcon, color: statusColor, size: 24),
                          ],
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .8,
                          child: SfCartesianChart(
                            margin: const EdgeInsets.all(0),
                            plotAreaBorderWidth: 0,
                            primaryXAxis: CategoryAxis(
                              labelStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              labelRotation: -45,
                              title: AxisTitle(
                                text: 'Day',
                                alignment: ChartAlignment.far,
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              majorGridLines: const MajorGridLines(width: 0),
                              majorTickLines: const MajorTickLines(width: 0),
                            ),
                            primaryYAxis: NumericAxis(
                              labelStyle: const TextStyle(fontSize: 18),
                              minimum: 0,
                              interval: _getInterval(monthlyData),
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
                            axes: <ChartAxis>[
                              NumericAxis(
                                title: AxisTitle(
                                  text: 'K\$',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                name: 'CumulativeAxis',
                                opposedPosition: true,
                                minimum: 0,
                                maximum: _getMaxCumulativeYAxis(monthlyData),
                                interval: 1,
                                majorGridLines: const MajorGridLines(width: 0),
                                minorGridLines: const MinorGridLines(width: 0),
                                majorTickLines: const MajorTickLines(width: 0),
                                minorTickLines: const MinorTickLines(width: 0),
                                // 👈 thêm nếu cần
                                // Tắt lưới chính ,
                                labelStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              header: '',
                              canShowMarker: true,
                              textStyle: TextStyle(
                                fontSize: 20,
                              ),

                            ),
                            series: _buildStackedSeries(monthlyData),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              _buildLegendItem(
                                color: Colors.green,
                                label: 'Target Achieved',
                                isActual: true,
                              ),
                              _buildLegendItem(
                                color: Colors.red,
                                label: 'Actual > Target (Negative)',
                              ),
                              _buildLegendItem(color: Colors.blue, label: 'ACT'),
                              _buildLegendItem(
                                color: Colors.orange,
                                label: 'FC_Adjust',
                              ),
                              _buildLegendItem(color: Colors.grey, label: 'FC_ORG'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  int getLastNonZeroIndex(List<ToolCostSubDetailModel> data) {
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i].targetAdjust != 0) {
        return i;
      }
    }
    return -1; // Trường hợp toàn bộ là 0
  }


  List<CartesianSeries<ToolCostSubDetailModel, String>> _buildStackedSeries(
    List<ToolCostSubDetailModel> data,
  ) {
    List<double> cumulativeActual = [];
    List<double> cumulativeTarget = [];
    List<double> cumulativeTargetDemo = [];

    double totalActual = 0;
    double totalTarget = 0;
    double totalTargetDemo = 0;

    for (var item in data) {
      totalActual += item.act;
      totalTarget += item.targetAdjust;
      totalTargetDemo += item.targetDemo;
      cumulativeActual.add(totalActual);
      cumulativeTarget.add(totalTarget);
      cumulativeTargetDemo.add(totalTargetDemo);
    }

    final now = DateTime.now();

    // Xác định ngày bắt đầu của tháng
    DateTime startOfMonth;
    if (selectedDate.year == now.year && selectedDate.month == now.month) {
      // Nếu là tháng hiện tại, lấy ngày 1 của tháng hiện tại
      startOfMonth = DateTime(now.year, now.month, 1);
    } else {
      // Nếu không phải tháng hiện tại, lấy ngày 1 của tháng đã chọn
      startOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    }

    // Xác định ngày hôm qua (không cộng thêm ngày)
    final yesterday = now.subtract(const Duration(days: 1));

    // Lọc dữ liệu: từ startOfMonth đến ngày hôm qua
    final filteredData =
        data
            .where(
              (d) =>
                  d.date.isAfter(
                    startOfMonth.subtract(const Duration(days: 1)),
                  ) &&
                  d.date.isBefore(yesterday),
            ) // Không cộng thêm 1 ngày
            .toList();

    // Cập nhật cumulativeActual theo filteredData
    final filteredCumulativeActual =
        cumulativeActual.take(filteredData.length).toList();

    final int lastNonZeroIndex = getLastNonZeroIndex(data);

    return <CartesianSeries<ToolCostSubDetailModel, String>>[
      StackedColumnSeries<ToolCostSubDetailModel, String>(
        dataSource: data,
        dataLabelMapper: (item, _) => numberFormat.format(item.act),
        xValueMapper: (d, _) => DateFormat('dd').format(d.date),
        yValueMapper: (d, _) => d.act,
        pointColorMapper:
            (item, _) =>
                item.act > item.targetAdjust ? Colors.red : Colors.green,
        name: 'Within Target',
        width: 1,
        spacing: .2,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),

        onPointTap: (ChartPointDetails details) async {
          final index = details.pointIndex ?? -1;
          final item = data[index];
          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          try {
            String month = DateFormat('yyyy-MM-dd').format(item.date);

            // Gọi API để lấy dữ liệu
            List<DetailsDataModel> detailsData = await ApiService()
                .fetchToolCostsSubSubDetail(
                  month,
                  widget.item.title,
                  widget.detail.title,
                );

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

      AreaSeries<ToolCostSubDetailModel, String>(
        dataSource: data,
        dataLabelMapper: (item, index) {
          return index == lastNonZeroIndex
              ? numberFormat.format(item.targetAdjust)
              : null;
        },
        // dataLabelMapper: (item, _) => numberFormat.format(item.targetAdjust),
        xValueMapper: (item, _) => DateFormat('dd').format(item.date),
        yValueMapper: (item, _) => item.targetAdjust,
        name: 'Target',
        gradient: LinearGradient(
          colors: [Colors.grey.withOpacity(0.5), Colors.grey.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: Colors.grey,
        borderWidth: 2,
        dataLabelSettings: const DataLabelSettings(
          labelAlignment: ChartDataLabelAlignment.top,
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),

        ),

      ),

      LineSeries<ToolCostSubDetailModel, String>(
        dataSource: filteredData,
        xValueMapper: (d, index) => DateFormat('dd').format(d.date),
        yValueMapper: (d, index) => filteredCumulativeActual[index],
        yAxisName: 'CumulativeAxis',
        name: 'Cumulative Actual',
        color: Colors.blue,
        width: 4,
        enableTooltip: true,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(
          labelAlignment: ChartDataLabelAlignment.auto,
          isVisible: true,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 18,
          ),
        ),
        dashArray: [0, 0],
        dataLabelMapper: (d, index) {
          return index == filteredCumulativeActual.length - 1
              ? filteredCumulativeActual[index].toStringAsFixed(1)
              : '';
        },
      ),

      LineSeries<ToolCostSubDetailModel, String>(
        dataSource: data,
        xValueMapper: (d, index) => DateFormat('dd').format(d.date),
        yValueMapper: (d, index) => cumulativeTarget[index],
        yAxisName: 'CumulativeAxis',
        name: 'Cumulative Target',
        color: Colors.orange,
        width: 4,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            fontSize: 18,
          ),
        ),
        dashArray: [0, 0],
        dataLabelMapper: (d, index) {
          return index == data.length - 1
              ? cumulativeTarget[index].toStringAsFixed(1)
              : '';
        },
      ),

      LineSeries<ToolCostSubDetailModel, String>(
        dataSource: data,
        xValueMapper: (d, index) => DateFormat('dd').format(d.date),
        yValueMapper: (d, index) => cumulativeTargetDemo[index],
        yAxisName: 'CumulativeAxis',
        name: 'Cumulative Target Demo',
        color: Colors.grey,
        width: 4,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
        dashArray: [0, 0],
        dataLabelMapper: (d, index) {
          return index == data.length - 1
              ? cumulativeTargetDemo[index].toStringAsFixed(1)
              : '';
        },
      ),
    ];
  }

  double _getInterval(List<ToolCostSubDetailModel> data) {
    if (data.isEmpty) return 1.0;

    double maxVal = data
        .map((e) => e.act > e.targetAdjust ? e.act : e.targetAdjust)
        .reduce((a, b) => a > b ? a : b);

    double interval = (maxVal / 5).ceilToDouble();
    return interval < 1.0 ? 1.0 : interval; // tránh interval quá nhỏ
  }

  double _getMaxYAxis(List<ToolCostSubDetailModel> data) {
    if (data.isEmpty)
      return 100; // hoặc 0, hoặc 1 — tuỳ bạn muốn hiển thị gì khi không có dữ liệu

    final maxVal = data
        .map((e) => e.act > e.targetAdjust ? e.act : e.targetAdjust)
        .reduce((a, b) => a > b ? a : b);

    return (maxVal * 1.3).ceilToDouble();
  }

  double _getMaxCumulativeYAxis(List<ToolCostSubDetailModel> data) {
    if (data.isEmpty) return 1.0; // fallback nếu không có dữ liệu

    double totalActual = 0;
    double totalTarget = 0;
    for (var item in data) {
      totalActual += item.act;
      totalTarget += item.targetDemo;
    }

    final maxCumulative = totalActual > totalTarget ? totalActual : totalTarget;
    return (maxCumulative * 1.1)
        .ceilToDouble(); // dữ liệu đã chia 1000 sẵn rồi nên giữ nguyên
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    bool isActual = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: isActual ? BoxShape.rectangle : BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
