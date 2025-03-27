import 'package:flutter/material.dart';
import 'package:open_finance_app/models/assets_details_model.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/models/assets_model.dart';
import 'package:intl/intl.dart';

/// A widget that displays a card for an asset product summary or a detailed asset item.
/// It shows the asset name, total value, portfolio percentage, and optionally gain/loss data.
class AssetsCard extends StatelessWidget {
  /// The asset product summary (optional).
  final ProductDetail? product;

  /// The detailed asset item (optional). Use this for the detailed view.
  final AssetsDetailsItem? item;

  /// Constructs an [AssetsCard] widget.
  /// Either [product] or [item] should be provided.
  const AssetsCard({
    super.key,
    this.product,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Create a number formatter for currency display.
    final numberFormat = NumberFormat.currency(symbol: "\$");

    // Retrieve asset values based on whether a product or an item is provided.
    final String name = product?.productName ?? item?.itemName ?? '';
    final double total = product?.prodTotal ?? item?.itemAmount ?? 0.0;
    final double portfolioPercentage =
        product?.portfolioPercentage ?? item?.portfolioPercentage ?? 0.0;

    // Gain/Loss values are applicable only if a detailed item is provided.
    final double? gainLoss = item?.itemProfitLoss;
    final double? gainLossPercent = item?.itemProfitLossPercentage;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display the asset name.
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          // Divider for visual separation.
          const Divider(
            color: AppColors.dividerColor,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 8),
          // Display total value.
          _buildRow("Total value", numberFormat.format(total)),
          // Display portfolio percentage.
          _buildRow(
            "% of account",
            "${portfolioPercentage.toStringAsFixed(2)}%",
          ),
          // If detailed item data exists, display gain/loss information.
          if (gainLoss != null && gainLossPercent != null) ...[
            const SizedBox(height: 8),
            _buildRow(
              "Gain/Loss",
              numberFormat.format(gainLoss),
              color: gainLoss >= 0 ? Colors.green : Colors.red,
            ),
            _buildRow(
              "Gain/Loss %",
              "${gainLossPercent.toStringAsFixed(2)}%",
              color: item!.itemProfitLossPercentage >= 0
                  ? Colors.green
                  : Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  /// Helper method to build a row with a label and its corresponding value.
  Widget _buildRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label text.
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          // Value text with optional color.
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
