class Connection {
  Connection({
    required this.clientId,
    required this.numConnections,
    required this.totalAmount,
    required this.connections,
    required this.timestamp,
  });

  final int? clientId;
  final int? numConnections;
  final double? totalAmount;
  final List<ConnectionElement> connections;
  final DateTime? timestamp;

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

  @override
  String toString() {
    return "$clientId, $numConnections, $totalAmount, $connections, $timestamp, ";
  }
}

class ConnectionElement {
  ConnectionElement({
    required this.bankName,
    required this.bankId,
    required this.accountNumber,
    required this.connectionId,
    required this.connectionAmount,
    required this.connectionPercentage,
    required this.isActive,
  });

  final String? bankName;
  final int? bankId;
  final int? accountNumber;
  final int? connectionId;
  final double? connectionAmount;
  final double? connectionPercentage;
  bool? isActive;

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

  @override
  String toString() {
    return "$bankName, $bankId, $accountNumber, $connectionId, $connectionAmount, $connectionPercentage, $isActive, ";
  }
}

/*
{
	"clientID": 1,
	"numConnections": 2,
	"totalAmount": 29543.64,
	"connections": [
		{
			"bankName": "Royal Bank of Canada",
			"bankID": 3,
			"accountNumber": 1234567,
			"connectionID": 1,
			"connectionAmount": 25654.51,
			"connectionPercentage": 86.84,
			"isActive": true
		},
		{
			"bankName": "The Bank of Nova Scotia",
			"bankID": 2,
			"accountNumber": 2345678,
			"connectionID": 2,
			"connectionAmount": 3889.13,
			"connectionPercentage": 13.16,
			"isActive": true
		},
		{
			"bankName": "The Bank of Nova Scotia",
			"bankID": 2,
			"accountNumber": 8887654,
			"connectionID": 3,
			"connectionAmount": 0,
			"connectionPercentage": 0,
			"isActive": false
		},
		{
			"bankName": "Wealthsimple Investments Inc.",
			"bankID": 703,
			"accountNumber": 666777,
			"connectionID": 6,
			"connectionAmount": 0,
			"connectionPercentage": 0,
			"isActive": false
		}
	],
	"timestamp": "2025-03-04T19:26:17.0764209Z"
}*/
