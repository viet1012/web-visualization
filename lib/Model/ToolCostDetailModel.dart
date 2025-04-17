class ToolCostDetailModel {
  final String title;
  final double target;
  final double actual;

  ToolCostDetailModel({
    required this.title,
    required this.target,
    required this.actual,
  });

  // Factory constructor to create a ToolCostModel from JSON
  factory ToolCostDetailModel.fromJson(Map<String, dynamic> json) {
    return ToolCostDetailModel(
      title: json['dept'] ?? '',
      target: double.parse(((json['tgt_MTD'] ?? 0.0).toDouble() / 1000).toStringAsFixed(1)),
      actual: double.parse(((json['act'] ?? 0.0).toDouble() / 1000).toStringAsFixed(1)),
    );
  }

  // Method to convert ToolCostModel to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'dept': title,
      'tgt_MTD': target * 1000,  // Chuyển đổi lại nếu cần
      'act': actual * 1000,       // Chuyển đổi lại nếu cần
    };
  }
}
