import 'package:flutter/material.dart';
import '../API/ApiService.dart';
import '../Model/ToolCostDetailModel.dart';
import '../Model/ToolCostModel.dart';

class ToolCostDetailProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ToolCostDetailModel> _data = [];
  ToolCostModel? _summary; // Dữ liệu từ API thứ 2
  DateTime? _lastLoadedDate;
  String? _lastLoadedMonth;
  String? _currentDept;
  bool _isLoading = false;

  List<ToolCostDetailModel> get data => _data;
  ToolCostModel? get summary => _summary; // expose ra ngoài
  bool get isLoading => _isLoading;
  ToolCostDetailModel? selectedItem;


  /// Gọi cả 2 API khi cần
  Future<void> fetchToolCostsDetail(String month, String dept) async {
    final now = DateTime.now();

    if (_lastLoadedDate != null &&
        _lastLoadedMonth == month &&
        _currentDept == dept &&
        _lastLoadedDate!.day == now.day &&
        _lastLoadedDate!.month == now.month &&
        _lastLoadedDate!.year == now.year) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final detailResult = await _apiService.fetchToolCostsDetail(month, dept);
    final summaryResult = await _apiService.fetchToolCostsByDept(month, dept);

    _data = detailResult;
    _summary = summaryResult;

    _lastLoadedDate = now;
    _lastLoadedMonth = month;
    _currentDept = dept;

    _isLoading = false;
    notifyListeners();
  }

  void setSelectedItem(ToolCostDetailModel item) {
    selectedItem = item;
    notifyListeners();
  }

  void clearData() {
    _data = [];
    _summary = null;
    _lastLoadedDate = null;
    _lastLoadedMonth = null;
    _currentDept = null;
    notifyListeners();
  }
}
