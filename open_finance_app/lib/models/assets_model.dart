/// Represents a summary of assets for a client.
/// This model contains an overall summary along with a list of product details.
class AssetsSummary {
  /// The client's unique identifier.
  final int clientID;

  /// The number of asset products.
  final int numProducts;

  /// The total monetary value of all assets.
  final double totalAmount;

  /// A list of detailed product information.
  final List<ProductDetail> productDetails;

  /// The timestamp indicating when the data was fetched or last updated.
  final DateTime timestamp;

  /// Constructs an [AssetsSummary] instance with the provided values.
  AssetsSummary({
    required this.clientID,
    required this.numProducts,
    required this.totalAmount,
    required this.productDetails,
    required this.timestamp,
  });

  /// Factory constructor to create an [AssetsSummary] object from JSON.
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

/// Represents the details of a single asset product.
class ProductDetail {
  /// The name of the asset product.
  final String productName;

  /// The total monetary value for the product.
  final double prodTotal;

  /// The percentage of the overall portfolio represented by this product.
  final double portfolioPercentage;

  /// Constructs a [ProductDetail] instance with the provided values.
  ProductDetail({
    required this.productName,
    required this.prodTotal,
    required this.portfolioPercentage,
  });

  /// Factory constructor to create a [ProductDetail] object from JSON.
  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productName: json['productName'] ?? '',
      prodTotal: (json['prodTotal'] as num?)?.toDouble() ?? 0.0,
      portfolioPercentage:
          (json['portfolioPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
