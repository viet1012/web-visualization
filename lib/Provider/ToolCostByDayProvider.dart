import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visualization/Model/ToolCostByDayModel.dart';
import '../API/ApiService.dart';

class ToolCostByDayProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ToolCostByDayModel> _byDayData = [];
  List<ToolCostByDayModel> get byDayData => _byDayData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _lastLoadedMonth;
  String? _currentDept;
  DateTime? _lastLoadedDate;
  Timer? _dailyTimer;

  final DateTime _lastFetchedDate = DateTime.now();
  DateTime get lastFetchedDate => _lastFetchedDate;


  Future<void> fetchToolCostsByDay(
      String month, String deptInput) async {
    final now = DateTime.now();

    if (_lastLoadedDate != null &&
        _lastLoadedMonth == month &&
        _currentDept == deptInput &&
        _lastLoadedDate!.day == now.day &&
        _lastLoadedDate!.month == now.month &&
        _lastLoadedDate!.year == now.year) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final subDetailResult = await _apiService.fetchToolCostsByDay(month, deptInput);
    _byDayData = subDetailResult;

    _lastLoadedDate = now;
    _lastLoadedMonth = month;
    _currentDept = deptInput;

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _dailyTimer?.cancel();
    super.dispose();
  }

  void clearData() {
    _byDayData = [];
    _lastLoadedMonth = null;
    _currentDept = null;
    _lastLoadedDate = null;
    notifyListeners();
  }
}
