class AssetsDetails {
  final int clientID;
  final int numProducts;
  final double totalAmount;
  final List<AssetsDetailsProduct> products;
  final DateTime timestamp;

  AssetsDetails({
    required this.clientID,
    required this.numProducts,
    required this.totalAmount,
    required this.products,
    required this.timestamp,
  });

  /// Parse the JSON from backend into an AssetsDetails object.
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

/// Represents each product in the "products" (e.g. "Stock", "Mutual Fund").
class AssetsDetailsProduct {
  final String productName;
  final int numItems;
  final double productTotalAmount;
  final double portfolioPercentage;
  final double productTotalAmountInvested;
  final double productTotalProfitLoss;
  final double productTotalProfitLossPercentage;
  final List<AssetsDetailsItem> items;

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

/// Represents each "item" inside a product (e.g. "AAPL", "RY", or mutual funds).
class AssetsDetailsItem {
  final String itemName;
  final int itemID;
  final double itemQuantity;
  final double itemLastPrice;
  final double itemAveragePrice;
  final double itemAmount;
  final double itemAmountInvested;
  final double itemProfitLoss;
  final double itemProfitLossPercentage;
  final double portfolioPercentage;

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
