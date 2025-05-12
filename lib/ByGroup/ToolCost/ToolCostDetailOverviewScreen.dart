import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Common/CustomToolCostAppBar.dart';
import '../../Common/NoDataWidget.dart';
import '../../Provider/DateProvider.dart';
import '../../Provider/ToolCost/ToolCostDetailProvider.dart';
import 'ToolCostDetailScreen.dart';

class ToolCostDetailOverviewScreen extends StatefulWidget {
  final String dept;
  final String month;

  const ToolCostDetailOverviewScreen({
    super.key,
    required this.dept,
    required this.month,
  });

  @override
  State<ToolCostDetailOverviewScreen> createState() =>
      _ToolCostDetailOverviewScreenState();
}

class _ToolCostDetailOverviewScreenState
    extends State<ToolCostDetailOverviewScreen>
    with RouteAware {
  // int selectedMonth = DateTime.now().month;
  // int selectedYear = DateTime.now().year;
  // DateTime selectedDate = DateTime(
  //   DateTime.now().year,
  //   DateTime.now().month,
  //   1,
  // );

  DateTime _currentDate = DateTime.now(); // Initialize directly
  Timer? _dailyTimer;
  final dayFormat = DateFormat('d-MMM-yyyy');
  late DateTime selectedDate;
  late String _currentDept;

  @override
  void didUpdateWidget(covariant ToolCostDetailOverviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dept != widget.dept || oldWidget.month != widget.month) {
      // selectedDate = _parseMonth(widget.month);
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   final provider = Provider.of<ToolCostDetailProvider>(
      //     context,
      //     listen: false,
      //   );
      //   _fetchData(provider); // Gọi lại API nếu dept thay đổi
      // });
      _updateDateFromUrl();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentDept = widget.dept;
    selectedDate = _parseMonth(widget.month); // 👈 Gán ngay tại initState!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("After build - Current Date: $_currentDate");
      //_updateDateFromUrl();
      final provider = Provider.of<ToolCostDetailProvider>(
        context,
        listen: false,
      );
      _fetchData(provider);
    });
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lắng nghe thay đổi URL trong `GoRouter`
    _updateDateFromUrl();
  }

  // Hàm này sẽ được gọi trong `initState` và `didUpdateWidget` để cập nhật ngày từ URL
  void _updateDateFromUrl() {
    final dateProvider = context.read<DateProvider>();
    final currentPath =
        GoRouter.of(context).routerDelegate.currentConfiguration;
    final provider = Provider.of<ToolCostDetailProvider>(
      context,
      listen: false,
    );

    final queryParameters = currentPath.uri.queryParameters;
    final currentMonth = queryParameters['month'];

    // ✅ Sửa ở đây: lấy dept đúng từ pathSegments[1]
    final pathSegments = currentPath.uri.pathSegments;
    String? deptFromUrl;
    if (pathSegments.length >= 2) {
      deptFromUrl = pathSegments[1];
    }

    if (deptFromUrl != null && deptFromUrl != _currentDept) {
      setState(() {
        _currentDept = deptFromUrl!;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchData(provider);
      });
    }

    if (currentMonth != null) {
      final newDate = _parseMonth(currentMonth);
      if (newDate != dateProvider.selectedDate) {
        print("New Date: $newDate");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          dateProvider.updateDate(newDate);
          _fetchData(provider);
        });
      }
    }
  }

  @override
  void dispose() {
    _dailyTimer?.cancel(); // 🧹 Dọn dẹp khi màn hình bị hủy
    super.dispose();
  }

  DateTime _parseMonth(String monthString) {
    final parts = monthString.split('-');
    final year = int.tryParse(parts[0]) ?? DateTime.now().year;
    final month = int.tryParse(parts[1]) ?? DateTime.now().month;
    return DateTime(year, month, 1);
  }

  //String month = "";
  // void _fetchData(ToolCostDetailProvider provider) {
  //   final fetchMonth = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}";
  //   // widget.month = "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
  //   print("fetchMonth in DetailScreen: $fetchMonth");
  //   provider.clearData(); // 👈 Reset trước khi fetch
  //   provider.fetchToolCostsDetail(fetchMonth, widget.dept);
  // }

  void _fetchData(ToolCostDetailProvider provider) {
    final dateProvider = context.read<DateProvider>();
    final fetchMonth =
        "${dateProvider.selectedDate.year}-${dateProvider.selectedDate.month.toString().padLeft(2, '0')}";
    print("fetchMonth in DetailScreen: $fetchMonth");
    provider.clearData();
    provider.fetchToolCostsDetail(fetchMonth, _currentDept);
  }

  @override
  Widget build(BuildContext context) {
    final toolCostDetailProvider = Provider.of<ToolCostDetailProvider>(context);
    final dateProvider =
        context.watch<DateProvider>(); // 👈 lấy ngày từ Provider

    return Scaffold(
      appBar: CustomToolCostAppBar(
        titleText: _currentDept,
        // selectedDate: selectedDate,
        selectedDate: dateProvider.selectedDate,

        // onDateChanged: (newDate) {
        //   setState(() {
        //     selectedDate = newDate;
        //     // selectedMonth = newDate.month;
        //     // selectedYear = newDate.year;
        //     // month = "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
        //   });
        //   // 👉 Gọi lại API
        //   final provider = Provider.of<ToolCostDetailProvider>(context, listen: false);
        //   _fetchData(provider);
        // },
        onDateChanged: (newDate) {
          // Cập nhật DateProvider
          context.read<DateProvider>().updateDate(newDate);

          // Cập nhật URL với tháng mới
          final newMonth =
              "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}";
          final newUrl =
              '/by-group/${widget.dept}?month=$newMonth'; // Tạo URL mới

          // Điều hướng đến URL mới
          GoRouter.of(context).go(newUrl);

          // Gọi lại API sau khi cập nhật DateProvider
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final provider = Provider.of<ToolCostDetailProvider>(
              context,
              listen: false,
            );
            _fetchData(provider);
          });
        },

        currentDate: toolCostDetailProvider.lastFetchedDate,
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
                          month: widget.month,
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
