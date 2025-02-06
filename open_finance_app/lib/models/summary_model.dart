class SummaryData {
  final int clientID;
  final double totalAmount;
  final DateTime timestamp;
  final List<ProductTotal> productTotals;

  /// Constructor
  SummaryData({
    required this.clientID,
    required this.totalAmount,
    required this.timestamp,
    required this.productTotals,
  });

  /// Factory method to create a SummaryData object from a JSON map
  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      clientID: json['clientID'] ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      productTotals: (json['productTotals'] as List<dynamic>?)
              ?.map((item) => ProductTotal.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ProductTotal {
  final String product;
  final double total;

  /// Constructor
  ProductTotal({
    required this.product,
    required this.total,
  });

  /// Factory method to create a ProductTotal object from a JSON map
  factory ProductTotal.fromJson(Map<String, dynamic> json) {
    return ProductTotal(
      product: json['product'] ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
