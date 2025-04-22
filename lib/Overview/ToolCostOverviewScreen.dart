import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visualization/Model/ToolCostModel.dart';

import '../Common/BlinkingText.dart';
import '../Common/CustomToolCostAppBar.dart';
import '../Common/DateDisplayWidget.dart';
import '../Common/MonthYearDropdown.dart';
import '../Common/NoDataWidget.dart';
import '../Common/TimeInfoCard.dart';
import '../Provider/ToolCostProvider.dart';
import '../main.dart';
import 'ToolCostOverviewChart.dart';

class ToolCostOverviewScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const ToolCostOverviewScreen({super.key, required this.onToggleTheme});

  @override
  State<ToolCostOverviewScreen> createState() => _ToolCostOverviewScreenState();
}

class _ToolCostOverviewScreenState extends State<ToolCostOverviewScreen> with RouteAware {
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("After build - Current Date: $_currentDate");
      final provider = Provider.of<ToolCostProvider>(context, listen: false);
      _fetchData(provider);
    });

    _dailyTimer = Timer.periodic(const Duration(minutes: 20), (timer) {
      final now = DateTime.now();
      print("[TIMER CHECK] Current Time: $now | Stored Time: $_currentDate");

      if (now.day != _currentDate.day ||
          now.month != _currentDate.month ||
          now.year != _currentDate.year) {
        print("[DATE CHANGED] Detected date change! Refreshing...");

        _currentDate = now;

        if (mounted) {
          final provider = Provider.of<ToolCostProvider>(
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
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _dailyTimer?.cancel(); // 🧹 Dọn dẹp khi màn hình bị hủy
    super.dispose();
  }

  String month = "";

  void _fetchData(ToolCostProvider provider) {
    month = "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
    provider.clearData(); // 👈 Reset trước khi fetch
    provider.fetchToolCosts(month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomToolCostAppBar(
      titleText: "Cost Monitoring",
      selectedDate: selectedDate,
      onDateChanged: (newDate) {
        setState(() {
          selectedDate = newDate;
          selectedMonth = newDate.month;
          selectedYear = newDate.year;
          month = "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
        });
        final provider = Provider.of<ToolCostProvider>(context, listen: false);
        _fetchData(provider);
      },
      currentDate: _currentDate,
      onToggleTheme: widget.onToggleTheme,
    ),
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
                          month: month,
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
