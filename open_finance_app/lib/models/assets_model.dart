class AssetsSummary {
  final int clientID;
  final int numProducts;
  final double totalAmount;
  final List<ProductDetail> productDetails;
  final DateTime timestamp;

  AssetsSummary({
    required this.clientID,
    required this.numProducts,
    required this.totalAmount,
    required this.productDetails,
    required this.timestamp,
  });

  /// Factory constructor to create an AssetsSummary object from JSON
  factory AssetsSummary.fromJson(Map<String, dynamic> json) {
    return AssetsSummary(
      clientID: json['clientID'] ?? 0,
      numProducts: json['numProducts'] ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      productDetails: (json['productDetails'] as List<dynamic>?)
              ?.map((item) => ProductDetail.fromJson(item))
              .toList() ??
          [],
    );
  }
}

/// Represents each item in "productDetails"
class ProductDetail {
  final String productName;
  final double prodTotal;
  final double portfolioPercentage;

  ProductDetail({
    required this.productName,
    required this.prodTotal,
    required this.portfolioPercentage,
  });

  /// Factory constructor to create ProductDetail from JSON
  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productName: json['productName'] ?? '',
      prodTotal: (json['prodTotal'] as num?)?.toDouble() ?? 0.0,
      portfolioPercentage:
          (json['portfolioPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
