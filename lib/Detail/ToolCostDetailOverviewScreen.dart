import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Common/BlinkingText.dart';
import '../Common/CustomToolCostAppBar.dart';
import '../Common/DateDisplayWidget.dart';
import '../Common/MonthYearDropdown.dart';
import '../Common/NoDataWidget.dart';
import '../Common/TimeInfoCard.dart';
import '../Provider/ToolCostDetailProvider.dart';
import 'DetailScreen.dart';
import 'ToolCostDetailScreen.dart';
import 'package:go_router/go_router.dart';

class ToolCostDetailOverviewScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final String dept;
  const ToolCostDetailOverviewScreen({super.key, required this.onToggleTheme, required this.dept});

  @override
  State<ToolCostDetailOverviewScreen> createState() => _ToolCostDetailOverviewScreenState();
}

class _ToolCostDetailOverviewScreenState extends State<ToolCostDetailOverviewScreen> with RouteAware {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  DateTime _currentDate = DateTime.now(); // Initialize directly
  Timer? _dailyTimer;
  final dayFormat = DateFormat('d-MMM-yyyy');

  @override
  void didUpdateWidget(covariant ToolCostDetailOverviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dept != widget.dept) {
      print("oldWidget: ${oldWidget.dept}" );
      WidgetsBinding.instance.addPostFrameCallback((_){
        final provider = Provider.of<ToolCostDetailProvider>(context, listen: false);
        _fetchData(provider); // Gọi lại API nếu dept thay đổi

      });

    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("After build - Current Date: $_currentDate");
      final provider = Provider.of<ToolCostDetailProvider>(context, listen: false);
      _fetchData(provider);
    });

    _dailyTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      final now = DateTime.now();
      print("[TIMER CHECK] Current Time: $now | Stored Time: $_currentDate");

      if (now.day != _currentDate.day ||
          now.month != _currentDate.month ||
          now.year != _currentDate.year) {
        print("[DATE CHANGED] Detected date change! Refreshing...");

        _currentDate = now;

        if (mounted) {
          final provider = Provider.of<ToolCostDetailProvider>(
            context,
            listen: false,
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedDate = DateTime(now.year, now.month, 1);
              selectedMonth = now.month;
              selectedYear = now.year;
            });
            _fetchData(provider);
          });
          print("[UI UPDATED] setState triggered with new date: $selectedDate");
        }
      }
    });

  }

  @override
  void didPopNext() {
    super.didPopNext();
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

  String month = "";

  void _fetchData(ToolCostDetailProvider provider) {
    month = "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
    provider.clearData(); // 👈 Reset trước khi fetch
    provider.fetchToolCostsDetail(month, widget.dept);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomToolCostAppBar(
          titleText: widget.dept,
          selectedDate: selectedDate,
          onDateChanged: (newDate) {
            setState(() {
              selectedDate = newDate;
              selectedMonth = newDate.month;
              selectedYear = newDate.year;
              month = "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
            });
            final provider = Provider.of<ToolCostDetailProvider>(context, listen: false);
            _fetchData(provider);
          },
          currentDate: _currentDate,
          showBackButton: true,
          onBack: () => context.go('/'),
        ),
      body: Consumer<ToolCostDetailProvider>(
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

          // ✅ Lấy tool cost summary từ provider (nếu muốn hiển thị)
          final summary = provider.summary;

          return SingleChildScrollView(
            child: Column(
              children: [
                if (summary != null)
                // 👇 Đây là phần hiện DetailScreen như trước
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.blue.shade100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ToolCostDetailScreen(
                        data: provider.data,
                        month: month,
                        toolCostModel: summary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }


}
