import 'package:flutter/material.dart';
import '../Model/ToolCostModel.dart';
import '../API/ApiService.dart';
class ToolCostProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ToolCostModel> _data = [];
  DateTime? _lastLoadedDate;
  String? _lastLoadedMonth; // Thêm dòng này
  bool _isLoading = false;

  List<ToolCostModel> get data => _data;
  bool get isLoading => _isLoading;
  ToolCostModel? selectedItem;

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
