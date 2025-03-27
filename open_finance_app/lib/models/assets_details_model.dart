/// Represents detailed asset information for a client.
/// This includes the overall summary and a list of individual products.
class AssetsDetails {
  /// The client's unique identifier.
  final int clientID;

  /// The number of asset products.
  final int numProducts;

  /// The total monetary value of the assets.
  final double totalAmount;

  /// A list of asset products (e.g., "Stock", "Mutual Fund").
  final List<AssetsDetailsProduct> products;

  /// The timestamp indicating when the data was fetched or last updated.
  final DateTime timestamp;

  /// Constructs an [AssetsDetails] instance with the provided values.
  AssetsDetails({
    required this.clientID,
    required this.numProducts,
    required this.totalAmount,
    required this.products,
    required this.timestamp,
  });

  /// Factory method that creates an [AssetsDetails] object from JSON.
  factory AssetsDetails.fromJson(Map<String, dynamic> json) {
    return AssetsDetails(
      clientID: json['clientID'] as int? ?? 0,
      numProducts: json['numProducts'] as int? ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      products: (json['products'] as List<dynamic>?)
              ?.map((p) => AssetsDetailsProduct.fromJson(p))
              .toList() ??
          [],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Represents a specific asset product (e.g., "Stock" or "Mutual Fund")
/// including its summary data and a list of detailed asset items.
class AssetsDetailsProduct {
  /// The name of the asset product.
  final String productName;

  /// The number of items/stocks held in this product.
  final int numItems;

  /// The total monetary amount for this product.
  final double productTotalAmount;

  /// The percentage of the portfolio that this product represents.
  final double portfolioPercentage;

  /// The total amount invested in this product.
  final double productTotalAmountInvested;

  /// The profit or loss amount for this product.
  final double productTotalProfitLoss;

  /// The profit or loss percentage for this product.
  final double productTotalProfitLossPercentage;

  /// A list of detailed asset items within this product.
  final List<AssetsDetailsItem> items;

  /// Constructs an [AssetsDetailsProduct] instance with the provided values.
  AssetsDetailsProduct({
    required this.productName,
    required this.numItems,
    required this.productTotalAmount,
    required this.portfolioPercentage,
    required this.productTotalAmountInvested,
    required this.productTotalProfitLoss,
    required this.productTotalProfitLossPercentage,
    required this.items,
  });

  /// Factory method that creates an [AssetsDetailsProduct] object from JSON.
  factory AssetsDetailsProduct.fromJson(Map<String, dynamic> json) {
    return AssetsDetailsProduct(
      productName: json['productName'] ?? '',
      numItems: json['numItems'] as int? ?? 0,
      productTotalAmount:
          (json['productTotalAmount'] as num?)?.toDouble() ?? 0.0,
      portfolioPercentage:
          (json['portfolioPercentage'] as num?)?.toDouble() ?? 0.0,
      productTotalAmountInvested:
          (json['productTotalAmountInvested'] as num?)?.toDouble() ?? 0.0,
      productTotalProfitLoss:
          (json['productTotalProfitLoss'] as num?)?.toDouble() ?? 0.0,
      productTotalProfitLossPercentage:
          (json['productTotalProfitLossPercentage'] as num?)?.toDouble() ?? 0.0,
      items: (json['items'] as List<dynamic>?)
              ?.map((i) => AssetsDetailsItem.fromJson(i))
              .toList() ??
          [],
    );
  }
}

/// Represents a single asset item within a product (e.g., a specific stock or fund).
class AssetsDetailsItem {
  /// The name of the asset item.
  final String itemName;

  /// The unique identifier for the asset item.
  final int itemID;

  /// The quantity of the asset item held.
  final double itemQuantity;

  /// The latest price per unit of the asset item.
  final double itemLastPrice;

  /// The average price at which the asset item was acquired.
  final double itemAveragePrice;

  /// The current total value of the asset item.
  final double itemAmount;

  /// The total amount invested in the asset item.
  final double itemAmountInvested;

  /// The profit or loss amount for the asset item.
  final double itemProfitLoss;

  /// The profit or loss percentage for the asset item.
  final double itemProfitLossPercentage;

  /// The percentage of the portfolio that this item represents.
  final double portfolioPercentage;

  /// Constructs an [AssetsDetailsItem] instance with the provided values.
  AssetsDetailsItem({
    required this.itemName,
    required this.itemID,
    required this.itemQuantity,
    required this.itemLastPrice,
    required this.itemAveragePrice,
    required this.itemAmount,
    required this.itemAmountInvested,
    required this.itemProfitLoss,
    required this.itemProfitLossPercentage,
    required this.portfolioPercentage,
  });

  /// Factory method that creates an [AssetsDetailsItem] object from JSON.
  factory AssetsDetailsItem.fromJson(Map<String, dynamic> json) {
    return AssetsDetailsItem(
      itemName: json['itemName'] ?? '',
      itemID: json['itemID'] as int? ?? 0,
      itemQuantity: (json['itemQuantity'] as num?)?.toDouble() ?? 0.0,
      itemLastPrice: (json['itemLastPrice'] as num?)?.toDouble() ?? 0.0,
      itemAveragePrice: (json['itemAveragePrice'] as num?)?.toDouble() ?? 0.0,
      itemAmount: (json['itemAmount'] as num?)?.toDouble() ?? 0.0,
      itemAmountInvested:
          (json['itemAmountInvested'] as num?)?.toDouble() ?? 0.0,
      itemProfitLoss: (json['itemProfitLoss'] as num?)?.toDouble() ?? 0.0,
      itemProfitLossPercentage:
          (json['itemProfitLossPercentage'] as num?)?.toDouble() ?? 0.0,
      portfolioPercentage:
          (json['portfolioPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
