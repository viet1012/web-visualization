class ToolCostModel {
  final String title;
  final double target_ORG;
  final double target_Adjust;
  final double actual;

  ToolCostModel({
    required this.title,
    required this.target_ORG,
    required this.target_Adjust,
    required this.actual,
  });

  double adjustMinusOrg = 0;
  double orgMinusAdjust = 0;
  double borderInsideAdjust = 0; // 👈 NEW: để vẽ nét đứt trong Adjust

  void calculateDiff() {
    if (target_Adjust > target_ORG) {
      adjustMinusOrg = target_Adjust - target_ORG;
      orgMinusAdjust = 0;
      borderInsideAdjust = target_ORG;
    } else {
      orgMinusAdjust = target_ORG - target_Adjust;
      adjustMinusOrg = 0;
      borderInsideAdjust = 0;
    }
  }


  // Factory constructor to create a ToolCostModel from JSON
  // factory ToolCostModel.fromJson(Map<String, dynamic> json) {
  //   return ToolCostModel(
  //     title: json['dept'] ?? '',
  //     target_ORG: (json['tgt_ORG'] ?? 0) / 1000,
  //     actual: (json['act'] ?? 0) / 1000,
  //     target_Adjust: (json['tgt_Adjust'] ?? 0) / 1000,
  //   );
  // }

  factory ToolCostModel.fromJson(Map<String, dynamic> json) {
    final model = ToolCostModel(
      title: json['dept'] ?? '',
      target_ORG: (json['tgt_ORG'] ?? 0) / 1000,
      actual: (json['act'] ?? 0) / 1000,
      target_Adjust: (json['tgt_Adjust'] ?? 0) / 1000,
    );
    model.calculateDiff();
    return model;
  }

  // Method to convert ToolCostModel to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'dept': title,
      'tgt_MTD': target_ORG * 1000,  // Chuyển đổi lại nếu cần
      'act': actual * 1000,       // Chuyển đổi lại nếu cần
    };
  }
}
