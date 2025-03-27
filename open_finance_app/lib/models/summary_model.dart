/// Represents the overall summary data for a client's account.
/// Includes the total asset amount and a breakdown by product.
class SummaryData {
  /// The client's unique identifier.
  final int clientID;

  /// The total monetary value across all products.
  final double totalAmount;

  /// The timestamp indicating when the summary was generated.
  final DateTime timestamp;

  /// A list of product totals detailing each product's contribution.
  final List<ProductTotal> productTotals;

  /// Constructs a [SummaryData] instance with the provided values.
  SummaryData({
    required this.clientID,
    required this.totalAmount,
    required this.timestamp,
    required this.productTotals,
  });

  /// Factory method to create a [SummaryData] object from a JSON map.
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

/// Represents the total value for a single product type.
class ProductTotal {
  /// The name of the product (e.g., "Cash", "Stock", "Mutual Fund").
  final String product;

  /// The total monetary value for the product.
  final double total;

  /// Constructs a [ProductTotal] instance with the provided values.
  ProductTotal({
    required this.product,
    required this.total,
  });

  /// Factory method to create a [ProductTotal] object from a JSON map.
  factory ProductTotal.fromJson(Map<String, dynamic> json) {
    return ProductTotal(
      product: json['product'] ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
