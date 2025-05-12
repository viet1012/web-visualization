import 'dart:async';

import 'package:flutter/material.dart';

import '../../API/ApiService.dart';
import '../../Model/ToolCostSubDetailModel.dart';

class ToolCostSubDetailProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ToolCostSubDetailModel> _subDetails = [];
  List<ToolCostSubDetailModel> get subDetails => _subDetails;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _lastLoadedMonth;
  String? _currentDept;
  String? _currentGroup;
  DateTime? _lastLoadedDate;
  Timer? _dailyTimer;

  DateTime _lastFetchedDate = DateTime.now();
  DateTime get lastFetchedDate => _lastFetchedDate;

  ToolCostSubDetailProvider() {
    _initTimer();
  }

  void _initTimer() {
    _dailyTimer = Timer.periodic(Duration(minutes: 30), (timer) async {
      final now = DateTime.now();
      if (!_isSameDate(now, _lastFetchedDate)) {
        print("[SubDetail DATE CHANGED] Refreshing...");
        _lastFetchedDate = now;

        if (_lastLoadedMonth != null &&
            _currentDept != null &&
            _currentGroup != null) {
          await fetchToolCostsSubDetail(
            _lastLoadedMonth!,
            _currentDept!,
            _currentGroup!,
          );
        }
      }
    });
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> fetchToolCostsSubDetail(
    String month,
    String deptInput,
    String group,
  ) async {
    final now = DateTime.now();

    if (_lastLoadedDate != null &&
        _lastLoadedMonth == month &&
        _currentDept == deptInput &&
        _currentGroup == group &&
        _lastLoadedDate!.day == now.day &&
        _lastLoadedDate!.month == now.month &&
        _lastLoadedDate!.year == now.year) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final subDetailResult = await _apiService.fetchToolCostsSubDetail(
      month,
      deptInput,
      group,
    );
    _subDetails = subDetailResult;

    _lastLoadedDate = now;
    _lastLoadedMonth = month;
    _currentDept = deptInput;
    _currentGroup = group;

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _dailyTimer?.cancel();
    super.dispose();
  }

  void clearData() {
    _subDetails = [];
    _lastLoadedMonth = null;
    _currentDept = null;
    _currentGroup = null;
    _lastLoadedDate = null;
    notifyListeners();
  }
}
