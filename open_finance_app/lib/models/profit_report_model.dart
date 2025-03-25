class ProfitReport {
  final int clientID;
  final List<ProfitByMonth> profitReportByMonth;
  final DateTime timestamp;

  ProfitReport({
    required this.clientID,
    required this.profitReportByMonth,
    required this.timestamp,
  });

  factory ProfitReport.fromJson(Map<String, dynamic> json) {
    return ProfitReport(
      clientID: json['clientID'] ?? 0,
      profitReportByMonth: (json['profitReportByMonth'] as List<dynamic>?)
              ?.map((item) => ProfitByMonth.fromJson(item))
              .toList() ??
          [],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}

class ProfitByMonth {
  final String reportPeriod;
  final double totalAmountInvested;
  final double totalAmount;
  final double totalProfitLoss;
  final double totalProfitLossPercentage;

  ProfitByMonth({
    required this.reportPeriod,
    required this.totalAmountInvested,
    required this.totalAmount,
    required this.totalProfitLoss,
    required this.totalProfitLossPercentage,
  });

  factory ProfitByMonth.fromJson(Map<String, dynamic> json) {
    return ProfitByMonth(
      reportPeriod: json['ReportPeriod'] ?? '',
      totalAmountInvested:
          (json['totalAmountInvested'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      totalProfitLoss: (json['totalProfitLoss'] as num?)?.toDouble() ?? 0.0,
      totalProfitLossPercentage:
          (json['totalProfitLossPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
