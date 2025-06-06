class DetailsDataModel {
  final String dept;
  final String matnr;
  final String maktx;
  final String useDate;
  final String xblnr2;
  final String bktxt;
  final double qty;
  final String unit;
  final double amount;
  final String note;

  DetailsDataModel({
    required this.dept,
    required this.matnr,
    required this.maktx,
    required this.useDate,
    required this.xblnr2,
    required this.bktxt,
    required this.qty,
    required this.unit,
    required this.amount,
    required this.note,
  });

  factory DetailsDataModel.fromJson(Map<String, dynamic> json) {
    return DetailsDataModel(
      dept: json['dept'] ?? '',
      matnr: json['matnr'] ?? '',
      maktx: json['maktx'] ?? '',
      useDate: json['useDate'] ?? '',
      xblnr2: json['xblnr2'] ?? '',
      bktxt: json['bktxt'] ?? '',
      qty: (json['qty'] != null) ? (json['qty'] as num).toDouble() : 0.0,
      unit: json['unit'] ?? '',
      amount:
          (json['amount'] != null) ? (json['amount'] as num).toDouble() : 0.0,
      note: json['note'] ?? '',
    );
  }
}
