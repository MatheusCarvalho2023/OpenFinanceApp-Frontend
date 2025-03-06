import 'package:flutter/material.dart';

class ProductSummary extends StatelessWidget {
  final String productName;
  final double value;

  const ProductSummary({
    super.key,
    required this.productName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Exemplo: Mesmo Padding que você tinha no _buildSummaryItem
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            productName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
