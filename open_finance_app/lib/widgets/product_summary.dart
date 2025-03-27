import 'package:flutter/material.dart';

/// A widget that displays a summary of a product's total value.
/// Used in the summary screen to list each product's contribution.
class ProductSummary extends StatelessWidget {
  /// The name of the product.
  final String productName;

  /// The monetary value associated with the product.
  final double value;

  /// Constructs a [ProductSummary] widget with the provided product name and value.
  const ProductSummary({
    super.key,
    required this.productName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Apply vertical padding for spacing.
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display the product name.
          Text(
            productName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          // Display the product value formatted as currency.
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
