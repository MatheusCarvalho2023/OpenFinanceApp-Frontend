/// A model class representing a financial institution (bank) in the OpenFinance app.
///
/// This class contains information about banks that users can connect to,
/// including the bank's name, logo, and unique identifier.
class Bank {
  /// The display name of the bank.
  final String name;

  /// The bank's logo image data.
  ///
  /// This can be a base64 encoded string, URL, or other image representation.
  final dynamic logo;

  /// The unique identifier of the bank in the system.
  final int bankId;

  /// Creates a new Bank instance.
  ///
  /// [name] is the display name of the bank.
  /// [logo] is optional and represents the bank's logo.
  /// [bankId] is the unique identifier for the bank in the system.
  Bank({
    required this.name,
    this.logo,
    required this.bankId,
  });

  /// Creates a Bank instance from a JSON map.
  ///
  /// [json] is the map containing bank data from the API.
  /// 
  /// If 'bankName' is not provided in the JSON, defaults to 'Unknown Bank'.
  /// Returns a new Bank instance with properties populated from the JSON data.
  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['bankName'] ?? 'Unknown Bank',
      logo: json['logo'],
      bankId: json['bankID'],
    );
  }

  /// Converts this Bank instance to a JSON map.
  ///
  /// Returns a Map<String, dynamic> containing the bank's properties
  /// in a format suitable for JSON serialization.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
      'bankID': bankId,
    };
  }
}