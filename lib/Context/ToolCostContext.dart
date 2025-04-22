import '../Model/ToolCostDetailModel.dart';

class ToolCostDetailContext {
  final String month;
  final String dept;
  final List<ToolCostDetailModel> data;

  ToolCostDetailContext({required this.month, required this.dept, required this.data});
}
