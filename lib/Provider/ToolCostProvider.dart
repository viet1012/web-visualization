import 'dart:async';

import 'package:flutter/material.dart';
import '../Model/ToolCostModel.dart';
import '../API/ApiService.dart';
import '../Model/ToolCostSubDetailModel.dart';
class ToolCostProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ToolCostModel> _data = [];
  DateTime? _lastLoadedDate;
  String? _lastLoadedMonth; // Thêm dòng này
  bool _isLoading = false;

  List<ToolCostModel> get data => _data;
  bool get isLoading => _isLoading;
  ToolCostModel? selectedItem;

  DateTime _lastFetchedDate = DateTime.now();
  Timer? _dailyTimer;

  DateTime get lastFetchedDate => _lastFetchedDate;

  ToolCostProvider() {
    _initTimer();
  }

  void _initTimer() {
    _dailyTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      final now = DateTime.now();
      if (!_isSameDate(now, _lastFetchedDate)) {
        print("[DATE CHANGED] Detected date change! Refreshing...");
        _lastFetchedDate = now;
        final month = "${now.year}-${now.month.toString().padLeft(2, '0')}";
        fetchToolCosts(month);
      }
    });
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void dispose() {
    _dailyTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchToolCosts(String month) async {
    final now = DateTime.now();

    // Sửa điều kiện: nếu đã tải hôm nay VÀ cùng tháng thì không cần gọi lại
    if (_lastLoadedDate != null &&
        _lastLoadedMonth == month &&
        _lastLoadedDate!.day == now.day &&
        _lastLoadedDate!.month == now.month &&
        _lastLoadedDate!.year == now.year) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _apiService.fetchToolCosts(month);
    _data = result;
    _lastLoadedDate = now;
    _lastLoadedMonth = month; // Cập nhật tháng

    _isLoading = false;
    notifyListeners();
  }

  List<ToolCostSubDetailModel> _subDetailData = [];

  List<ToolCostSubDetailModel> get subDetailData => _subDetailData;

  Future<void> fetchToolCostsSubDetail(String month, String dept, String group) async {
    final now = DateTime.now();

    // Sửa điều kiện: nếu đã tải hôm nay VÀ cùng tháng thì không cần gọi lại
    if (_lastLoadedDate != null &&
        _lastLoadedMonth == month &&
        _lastLoadedDate!.day == now.day &&
        _lastLoadedDate!.month == now.month &&
        _lastLoadedDate!.year == now.year) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await _apiService.fetchToolCostsSubDetail(month,dept,group);
    _subDetailData = result;
    _lastLoadedDate = now;
    _lastLoadedMonth = month; // Cập nhật tháng

    _isLoading = false;
    notifyListeners();
  }




  void setSelectedItem(ToolCostModel item) {
    selectedItem = item;
    notifyListeners(); // Thông báo rằng có sự thay đổi dữ liệu
  }


  void clearData() {
    _data = [];
    _lastLoadedDate = null;
    _lastLoadedMonth = null; // reset tháng
    notifyListeners();
  }
}
