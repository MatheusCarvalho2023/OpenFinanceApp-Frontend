/// Represents the profit report for a client.
/// Contains a list of monthly profit data along with a timestamp.
class ProfitReport {
  /// The client's unique identifier.
  final int clientID;

  /// A list of profit data entries by month.
  final List<ProfitByMonth> profitReportByMonth;

  /// The timestamp indicating when the report was generated.
  final DateTime timestamp;

  /// Constructs a [ProfitReport] instance with the provided values.
  ProfitReport({
    required this.clientID,
    required this.profitReportByMonth,
    required this.timestamp,
  });

  /// Factory method that creates a [ProfitReport] object from JSON.
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

/// Represents the profit details for a specific month.
class ProfitByMonth {
  /// The period for the report (typically in a "MM-YYYY" format).
  final String reportPeriod;

  /// The total amount invested during the period.
  final double totalAmountInvested;

  /// The total asset amount during the period.
  final double totalAmount;

  /// The net profit or loss amount.
  final double totalProfitLoss;

  /// The profit or loss percentage.
  final double totalProfitLossPercentage;

  /// Constructs a [ProfitByMonth] instance with the provided values.
  ProfitByMonth({
    required this.reportPeriod,
    required this.totalAmountInvested,
    required this.totalAmount,
    required this.totalProfitLoss,
    required this.totalProfitLossPercentage,
  });

  /// Factory method that creates a [ProfitByMonth] object from JSON.
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
