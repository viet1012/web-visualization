  import 'dart:async';

  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:provider/provider.dart';
  import '../Common/CustomToolCostAppBar.dart';
  import '../Common/NoDataWidget.dart';
  import '../Provider/DateProvider.dart';
import '../Provider/ToolCostProvider.dart';
  import '../main.dart';
  import 'ToolCostOverviewChart.dart';

  class ToolCostOverviewScreen extends StatefulWidget {
    final VoidCallback onToggleTheme;
    final DateTime selectedDate; // 👈 Thêm dòng này
    const ToolCostOverviewScreen({
      super.key,
      required this.onToggleTheme,
      required this.selectedDate,
    });

    @override
    State<ToolCostOverviewScreen> createState() => _ToolCostOverviewScreenState();
  }

  class _ToolCostOverviewScreenState extends State<ToolCostOverviewScreen> {
    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;
    DateTime selectedDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1,
    );

    Timer? _dailyTimer;
    final dayFormat = DateFormat('d-MMM-yyyy');

    @override
    void didUpdateWidget(covariant ToolCostOverviewScreen oldWidget) {
      super.didUpdateWidget(oldWidget);

      // Kiểm tra sự thay đổi của selectedDate từ DateProvider
      // final dateProvider = Provider.of<DateProvider>(context, listen: false);
      final dateProvider = context.read<DateProvider>();
      if (oldWidget.selectedDate != dateProvider.selectedDate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final toolCostProvider = Provider.of<ToolCostProvider>(context, listen: false);
          final newMonth =
              "${dateProvider.selectedDate.year}-${dateProvider.selectedDate.month.toString().padLeft(2, '0')}";
          print("newMonth: $newMonth");
          toolCostProvider.fetchToolCosts(newMonth);
        });
      }
    }

    @override
    void initState() {
      super.initState();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<ToolCostProvider>(context, listen: false);
        _fetchData(provider);
      });

    }

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
    }

    @override
    void dispose() {
      _dailyTimer?.cancel(); // 🧹 Dọn dẹp khi màn hình bị hủy
      super.dispose();
    }


    // void _fetchData(ToolCostProvider provider) {
    //   final month = "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
    //   print("month in ToolCostOverviewScreen: $month");
    //   provider.clearData(); // 👈 Reset trước khi fetch
    //   provider.fetchToolCosts(month);
    // }

    void _fetchData(ToolCostProvider provider) {
      final dateProvider = context.read<DateProvider>();
      final month = "${dateProvider.selectedDate.year}-${dateProvider.selectedDate.month.toString().padLeft(2, '0')}";
      print("month in ToolCostOverviewScreen: $month");
      provider.clearData(); // 👈 Reset trước khi fetch
      provider.fetchToolCosts(month);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Consumer<ToolCostProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.data.isEmpty) {
              return const NoDataWidget(
                title: "No Data Available",
                message: "Please try again with a different time range.",
                icon: Icons.error_outline,
              );
            }

            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ToolCostOverviewChart(
                            data: provider.data,
                            month: "${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
