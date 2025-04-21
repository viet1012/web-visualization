import '../Model/ToolCostDetailModel.dart';

class ToolCostContext {
  final String month;
  final String dept;
  final List<ToolCostDetailModel> data;

  ToolCostContext({required this.month, required this.dept, required this.data});
}
