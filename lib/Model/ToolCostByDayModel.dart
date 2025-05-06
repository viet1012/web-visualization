class ToolCostByDayModel {
  final DateTime date;
  final double targetOrg;
  final double targetAdjust;
  final double act;
  final double divAdj;

  ToolCostByDayModel({
    required this.date,
    required this.targetOrg,
    required this.targetAdjust,
    required this.act,
    required this.divAdj,
  });

  factory ToolCostByDayModel.fromJson(Map<String, dynamic> json) {
    return ToolCostByDayModel(
      date: DateTime.parse(json['date']),
      targetOrg: (json['fcOrg'] ?? 0.0)/1000  ,
      targetAdjust: (json['fcAdjust'] ?? 0.0)/1000    ,
      act:  (json['act'] ?? 0.0).toDouble()/1000,
      divAdj:  (json['divAdj'] ?? 0.0)
    );
  }
}
