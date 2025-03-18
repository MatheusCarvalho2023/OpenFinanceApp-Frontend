import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/statement_card.dart';
import 'package:open_finance_app/models/statement_model.dart';
import 'package:open_finance_app/services/api_service.dart';

class StatementsScreen extends StatefulWidget {
  final int clientID;

  const StatementsScreen({super.key, required this.clientID});

  @override
  State<StatementsScreen> createState() => _StatementsScreenState();
}

class _StatementsScreenState extends State<StatementsScreen> {
  late Future<ClientStatement> _futureClientStatement;

  @override
  void initState() {
    super.initState();
    // Fetch the client statement data from the API
    _futureClientStatement = ApiService().fetchStatements(widget.clientID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<ClientStatement>(
        future: _futureClientStatement,
        builder: (context, snapshot) {
          // Show a loading spinner while waiting for the data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If an error occurs, show an error message
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // If no data is available, show a message
          else if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }
          // Otherwise, show the data
          final clientStatement = snapshot.data!;
          return _buildStatements(clientStatement);
        },
      ),
    );
  }

  /// Constructs content from the ClientStatement object
  Widget _buildStatements(ClientStatement clientStatement) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // For each month, show the month header and transactions
          for (final monthData in clientStatement.statement) ...[
            _buildMonthHeader(monthData.month),
            const SizedBox(height: 8),
            // show each transaction in a card
            for (final tx in monthData.transactions) ...[
              StatementCard(
                title: tx.transactionType,
                ticker: tx.assetName,
                date: tx.transactionDate,
                amount: tx.transactionAmount,
                currency: "CAD",
              ),
            ],
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  /// Simple widget to display the month and year.
  Widget _buildMonthHeader(String monthYear) {
    return Center(
      child: Text(
        monthYear,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
