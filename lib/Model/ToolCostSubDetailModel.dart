class ToolCostSubDetailModel {
  final DateTime date;
  final double targetDemo;
  final double targetAdjust;
  final double act;
  final double fcUSD;
  final double countDay;
  final double divAdj;
  final int wdOffice;

  ToolCostSubDetailModel({
    required this.date,
    required this.targetDemo,
    required this.targetAdjust,
    required this.act,
    required this.fcUSD,
    required this.countDay,
    required this.divAdj,
    required this.wdOffice,
  });

  factory ToolCostSubDetailModel.fromJson(Map<String, dynamic> json) {
    return ToolCostSubDetailModel(
      date: DateTime.parse(json['date']),
      targetDemo: (json['fc_ORG'] ?? 0).toDouble(),
      targetAdjust: (json['fc_Adjust'] ?? 0).toDouble(),
      act: (json['act'] ?? 0).toDouble(),
      fcUSD: (json['fc_USD'] ?? 0).toDouble(),
      countDay: (json['countDay'] ?? 0).toDouble(),
      divAdj: (json['div_adj'] ?? 0).toDouble(),
      wdOffice: (json['wd_Office'] ?? 0).toInt(),
    );
  }
}
