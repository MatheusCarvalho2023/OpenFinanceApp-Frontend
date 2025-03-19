class Client {
  Client({
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    required this.clientAddress,
  });

  final int? clientId;
  final String? clientName;
  final String? clientEmail;
  final String? clientAddress;

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientId: json["clientID"],
      clientName: json["clientName"],
      clientEmail: json["clientEmail"],
      clientAddress: json["clientAddress"],
    );
  }

  Map<String, dynamic> toJson() => {
        "clientID": clientId,
        "clientName": clientName,
        "clientEmail": clientEmail,
        "clientAddress": clientAddress,
      };

  @override
  String toString() {
    return "$clientId, $clientName, $clientEmail, $clientAddress, ";
  }
}

/*
{
	"clientID": 1,
	"clientName": "Fernando Test Account",
	"clientEmail": "test@mail.com",
	"clientAddress": "180 University Ave"
}*/