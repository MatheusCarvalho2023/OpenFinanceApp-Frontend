import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A widget that displays a statement record in a card.
/// It fills the horizontal space and shows relevant info
class StatementCard extends StatelessWidget {
  final String title;
  final String ticker;
  final DateTime date;
  final double amount;
  final String currency;

  const StatementCard({
    super.key,
    required this.title,
    required this.ticker,
    required this.date,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final numberFormat = NumberFormat.currency(symbol: "\$");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowColor, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // A divider line across the container
          const Divider(
            color: AppColors.dividerColor,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 8),
          // Ticker & date in one row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ticker),
              Text('$currency ${numberFormat.format(amount)}'),
            ],
          ),
          const SizedBox(height: 4),
          // Second row: date, quantity, price
          Text(dateFormat.format(date)),
        ],
      ),
    );
  }
}
