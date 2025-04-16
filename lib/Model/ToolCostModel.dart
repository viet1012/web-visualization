class ToolCostModel {
  final String title;
  final double target;
  final double actual;

  ToolCostModel({
    required this.title,
    required this.target,
    required this.actual,
  });

  // Factory constructor to create a ToolCostModel from JSON
  factory ToolCostModel.fromJson(Map<String, dynamic> json) {
    return ToolCostModel(
      title: json['dept'] ?? '',
      target: (json['tgt_MTD'] ?? 0.0).toDouble(),
      actual: (json['act'] ?? 0.0).toDouble(),
    );
  }

  // Method to convert ToolCostModel to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'dept': title,
      'tgt_MTD': target,
      'act': actual,
    };
  }
}
