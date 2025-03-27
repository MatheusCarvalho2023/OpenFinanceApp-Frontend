import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A widget that displays a transaction statement in a card format.
/// The card shows the transaction title, asset ticker, date, and amount.
class StatementCard extends StatelessWidget {
  /// The title of the transaction (e.g., "Buy", "Sell").
  final String title;

  /// The asset ticker or symbol involved.
  final String ticker;

  /// The date of the transaction.
  final DateTime date;

  /// The monetary amount of the transaction.
  final double amount;

  /// The currency in which the transaction was made.
  final String currency;

  /// Constructs a [StatementCard] widget with the specified transaction details.
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
    // Format the date and currency values.
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
          // Display transaction title.
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Divider for visual separation.
          const Divider(
            color: AppColors.dividerColor,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 8),
          // Row containing ticker and formatted amount.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ticker),
              Text('$currency ${numberFormat.format(amount)}'),
            ],
          ),
          const SizedBox(height: 4),
          // Display the transaction date.
          Text(dateFormat.format(date)),
        ],
      ),
    );
  }
}
