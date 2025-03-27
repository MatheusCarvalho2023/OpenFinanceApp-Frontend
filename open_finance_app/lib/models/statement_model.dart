/// Represents a complete client statement containing multiple months' statements.
class ClientStatement {
  /// The client's unique identifier.
  final int clientID;

  /// A list of statement data grouped by month.
  final List<StatementMonth> statement;

  /// The timestamp indicating when the statement was generated.
  final DateTime timestamp;

  /// Constructs a [ClientStatement] instance with the provided values.
  ClientStatement({
    required this.clientID,
    required this.statement,
    required this.timestamp,
  });

  /// Factory method that creates a [ClientStatement] object from JSON.
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

/// Represents the statement for a single month.
class StatementMonth {
  /// The month (and possibly year) for which the statement applies.
  final String month;

  /// A list of transactions that occurred during the month.
  final List<StatementTransaction> transactions;

  /// Constructs a [StatementMonth] instance with the provided values.
  StatementMonth({
    required this.month,
    required this.transactions,
  });

  /// Factory method that creates a [StatementMonth] object from JSON.
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

/// Represents a single transaction within a client's statement.
class StatementTransaction {
  /// Unique identifier for the transaction.
  final int transactionID;

  /// Identifier for the connection associated with the transaction.
  final int connectionID;

  /// Type of transaction (e.g., "Buy", "Sell", "Fee").
  final String transactionType;

  /// Direction of the transaction (e.g., "Credit" or "Debit").
  final String transactionDirection;

  /// Name of the asset involved in the transaction.
  final String assetName;

  /// The date on which the transaction occurred.
  final DateTime transactionDate;

  /// The monetary amount involved in the transaction.
  final double transactionAmount;

  /// Constructs a [StatementTransaction] instance with the provided values.
  StatementTransaction({
    required this.transactionID,
    required this.connectionID,
    required this.transactionType,
    required this.transactionDirection,
    required this.assetName,
    required this.transactionDate,
    required this.transactionAmount,
  });

  /// Factory method that creates a [StatementTransaction] object from JSON.
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
