class Bank {
  final String name;
  final dynamic logo;
  final int bankId;

  Bank({
    required this.name,
    this.logo,
    required this.bankId,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['bankName'] ?? 'Unknown Bank',
      logo: json['logo'],
      bankId: json['bankID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
      'bankID': bankId,
    };
  }
}