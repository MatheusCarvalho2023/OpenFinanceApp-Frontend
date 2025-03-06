import 'package:flutter/material.dart';
import 'package:open_finance_app/models/assets_details_model.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/models/assets_model.dart';
import 'package:intl/intl.dart';

class AssetsCard extends StatelessWidget {
  final ProductDetail? product;
  final AssetsDetailsItem? item; // Optional for detailed view

  const AssetsCard({
    super.key,
    this.product,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(symbol: "\$");

    // 1) Recupera os valores conforme o que for passado (product ou item)
    final String name = product?.productName ?? item?.itemName ?? '';
    final double total = product?.prodTotal ?? item?.itemAmount ?? 0.0;
    final double portfolioPercentage =
        product?.portfolioPercentage ?? item?.portfolioPercentage ?? 0.0;

    // Esses campos só existem se for um item de detalhe
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
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(
            color: AppColors.dividerColor,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 8),

          // Total value and % of account
          _buildRow("Total value", numberFormat.format(total)),
          _buildRow(
            "% of account",
            "${portfolioPercentage.toStringAsFixed(2)}%",
          ),

          // If it is "detail" (item != null), show gain/loss
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

  Widget _buildRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
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
