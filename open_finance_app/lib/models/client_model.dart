/// A model class representing a client in the application.
/// 
/// This class contains basic information about a client such as their ID,
/// name, email, and address. It also provides methods for JSON serialization
/// and deserialization.
class Client {
  /// Creates a new [Client] instance.
  /// 
  /// All parameters are required but can contain null values.
  /// 
  /// * [clientId]: The unique identifier for the client.
  /// * [clientName]: The full name of the client.
  /// * [clientEmail]: The email address of the client.
  /// * [clientAddress]: The physical address of the client.
  Client({
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    required this.clientAddress,
  });

  /// The unique identifier for the client.
  final int? clientId;
  
  /// The full name of the client.
  final String? clientName;
  
  /// The email address of the client.
  final String? clientEmail;
  
  /// The physical address of the client.
  final String? clientAddress;

  /// Creates a [Client] instance from a JSON map.
  /// 
  /// The JSON keys are expected to match the API response format:
  /// "clientID", "clientName", "clientEmail", "clientAddress".
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientId: json["clientID"],
      clientName: json["clientName"],
      clientEmail: json["clientEmail"],
      clientAddress: json["clientAddress"],
    );
  }

  /// Converts the [Client] instance to a JSON map.
  /// 
  /// The resulting map uses the API expected keys:
  /// "clientID", "clientName", "clientEmail", "clientAddress".
  Map<String, dynamic> toJson() => {
        "clientID": clientId,
        "clientName": clientName,
        "clientEmail": clientEmail,
        "clientAddress": clientAddress,
      };

  /// Returns a string representation of the client.
  /// 
  /// This is useful for debugging purposes.
  @override
  String toString() {
    return "$clientId, $clientName, $clientEmail, $clientAddress, ";
  }
}

/*
Example JSON structure from API:
{
    "clientID": 1,
    "clientName": "Fernando Test Account",
    "clientEmail": "test@mail.com",
    "clientAddress": "180 University Ave"
}*/