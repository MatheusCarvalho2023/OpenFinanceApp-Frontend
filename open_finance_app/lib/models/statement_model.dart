class ClientStatement {
  final int clientID;
  final List<StatementMonth> statement;
  final DateTime timestamp;

  ClientStatement({
    required this.clientID,
    required this.statement,
    required this.timestamp,
  });

  factory ClientStatement.fromJson(Map<String, dynamic> json) {
    return ClientStatement(
      clientID: json['clientID'] as int? ?? 0,
      statement: (json['statement'] as List<dynamic>?)
              ?.map((m) => StatementMonth.fromJson(m))
              .toList() ??
          [],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}

class StatementMonth {
  final String month;
  final List<StatementTransaction> transactions;

  StatementMonth({
    required this.month,
    required this.transactions,
  });

  factory StatementMonth.fromJson(Map<String, dynamic> json) {
    return StatementMonth(
      month: json['month'] as String? ?? '',
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((t) => StatementTransaction.fromJson(t))
              .toList() ??
          [],
    );
  }
}

class StatementTransaction {
  final int transactionID;
  final int connectionID;
  final String transactionType; // e.g. "Buy", "Sell", "Fee", etc.
  final String transactionDirection; // e.g. "Credit" ou "Debit"
  final String assetName;
  final DateTime transactionDate;
  final double transactionAmount;

  StatementTransaction({
    required this.transactionID,
    required this.connectionID,
    required this.transactionType,
    required this.transactionDirection,
    required this.assetName,
    required this.transactionDate,
    required this.transactionAmount,
  });

  factory StatementTransaction.fromJson(Map<String, dynamic> json) {
    return StatementTransaction(
      transactionID: json['transactionID'] as int? ?? 0,
      connectionID: json['connectionID'] as int? ?? 0,
      transactionType: json['transactionType'] as String? ?? '',
      transactionDirection: json['transactionDirection'] as String? ?? '',
      assetName: json['assetName'] as String? ?? '',
      transactionDate:
          DateTime.tryParse(json['transactionDate'] ?? '') ?? DateTime.now(),
      transactionAmount: (json['transactionAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
