/// A model class representing a client's financial connections data.
///
/// This class contains information about all financial connections a client has,
/// including total amounts, number of connections, and details for each connection.
class Connection {
  /// Creates a new [Connection] instance.
  ///
  /// * [clientId]: The unique identifier for the client.
  /// * [numConnections]: Total number of financial connections for the client.
  /// * [totalAmount]: Total monetary value across all active connections.
  /// * [connections]: List of individual connection details.
  /// * [timestamp]: When this data was generated/retrieved.
  Connection({
    required this.clientId,
    required this.numConnections,
    required this.totalAmount,
    required this.connections,
    required this.timestamp,
  });

  /// The unique identifier for the client.
  final int? clientId;
  
  /// Total number of financial connections for the client.
  final int? numConnections;
  
  /// Total monetary value across all active connections.
  final double? totalAmount;
  
  /// List of individual connection details.
  final List<ConnectionElement> connections;
  
  /// When this data was generated/retrieved.
  final DateTime? timestamp;

  /// Creates a [Connection] instance from a JSON map.
  ///
  /// [json] The map containing connection data from the API.
  ///
  /// Returns a new Connection instance with properties populated from the JSON data.
  /// If the 'connections' field is null in the JSON, an empty list is used.
  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      clientId: json["clientID"],
      numConnections: json["numConnections"],
      totalAmount: json["totalAmount"]?.toDouble(),
      connections: json["connections"] == null
          ? []
          : List<ConnectionElement>.from(
              json["connections"]!.map((x) => ConnectionElement.fromJson(x))),
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
    );
  }

  /// Returns a string representation of the connection data.
  ///
  /// This is useful for debugging purposes.
  @override
  String toString() {
    return "Connection(clientId: $clientId, numConnections: $numConnections, totalAmount: $totalAmount, connections: $connections, timestamp: $timestamp)";
  }
}

/// A model class representing an individual financial connection to a bank.
///
/// This class contains details about a specific bank account connection,
/// including the bank name, account number, and current balance.
class ConnectionElement {
  /// Creates a new [ConnectionElement] instance.
  ///
  /// * [bankName]: The name of the financial institution.
  /// * [bankId]: The unique identifier for the bank.
  /// * [accountNumber]: The account number at the bank.
  /// * [connectionId]: The unique identifier for this connection.
  /// * [connectionAmount]: The current monetary value/balance of the connection.
  /// * [connectionPercentage]: The percentage this connection represents of the total portfolio.
  /// * [isActive]: Whether this connection is currently active.
  ConnectionElement({
    required this.bankName,
    required this.bankId,
    required this.accountNumber,
    required this.connectionId,
    required this.connectionAmount,
    required this.connectionPercentage,
    required this.isActive,
  });

  /// The name of the financial institution.
  final String? bankName;
  
  /// The unique identifier for the bank.
  final int? bankId;
  
  /// The account number at the bank.
  final int? accountNumber;
  
  /// The unique identifier for this connection.
  final int? connectionId;
  
  /// The current monetary value/balance of the connection.
  final double? connectionAmount;
  
  /// The percentage this connection represents of the total portfolio.
  final double? connectionPercentage;
  
  /// Whether this connection is currently active.
  ///
  /// This is mutable as it can be toggled by the user.
  bool? isActive;

  /// Creates a [ConnectionElement] instance from a JSON map.
  ///
  /// [json] The map containing connection element data from the API.
  ///
  /// Returns a new ConnectionElement instance with properties populated from the JSON data.
  factory ConnectionElement.fromJson(Map<String, dynamic> json) {
    return ConnectionElement(
      bankName: json["bankName"],
      bankId: json["bankID"],
      accountNumber: json["accountNumber"],
      connectionId: json["connectionID"],
      connectionAmount: json["connectionAmount"]?.toDouble(),
      connectionPercentage: json["connectionPercentage"]?.toDouble(),
      isActive: json["isActive"],
    );
  }

  /// Returns a string representation of the connection element.
  ///
  /// This is useful for debugging purposes.
  @override
  String toString() {
    return "ConnectionElement(bankName: $bankName, bankId: $bankId, accountNumber: $accountNumber, connectionId: $connectionId, amount: $connectionAmount, percentage: $connectionPercentage, isActive: $isActive)";
  }
}

/// Example JSON structure from API:
/// ```json
/// {
///   "clientID": 1,
///   "numConnections": 2,
///   "totalAmount": 29543.64,
///   "connections": [
///     {
///       "bankName": "Royal Bank of Canada",
///       "bankID": 3,
///       "accountNumber": 1234567,
///       "connectionID": 1,
///       "connectionAmount": 25654.51,
///       "connectionPercentage": 86.84,
///       "isActive": true
///     },
///     {
///       "bankName": "The Bank of Nova Scotia",
///       "bankID": 2,
///       "accountNumber": 2345678,
///       "connectionID": 2,
///       "connectionAmount": 3889.13,
///       "connectionPercentage": 13.16,
///       "isActive": true
///     }
///   ],
///   "timestamp": "2025-03-04T19:26:17.0764209Z"
/// }
/// ```
