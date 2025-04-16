import 'package:flutter/material.dart';
import '../Model/ToolCostModel.dart';
import '../API/ApiService.dart';

class ToolCostProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ToolCostModel> _data = [];
  DateTime? _lastLoadedDate;
  bool _isLoading = false;

  List<ToolCostModel> get data => _data;
  bool get isLoading => _isLoading;

  Future<void> fetchToolCosts(String month) async {
    final now = DateTime.now();
    if (_lastLoadedDate != null &&
        _lastLoadedDate!.day == now.day &&
        _lastLoadedDate!.month == now.month &&
        _lastLoadedDate!.year == now.year) {
      return; // Đã tải hôm nay, không cần tải lại
    }

    _isLoading = true;
    notifyListeners();

    final result = await _apiService.fetchToolCosts(month);
    _data = result;
    _lastLoadedDate = now;

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _data = [];
    _lastLoadedDate = null;
    notifyListeners();
  }
}
