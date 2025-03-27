import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/statement_card.dart';
import 'package:open_finance_app/models/statement_model.dart';
import 'package:open_finance_app/services/api_service.dart';

/// StatementsScreen displays client statements by month.
/// It fetches the statement data from the API and displays each month's transactions.
class StatementsScreen extends StatefulWidget {
  /// The client ID used to fetch the statements.
  final int clientID;

  /// Constructor for StatementsScreen.
  const StatementsScreen({super.key, required this.clientID});

  @override
  State<StatementsScreen> createState() => _StatementsScreenState();
}

class _StatementsScreenState extends State<StatementsScreen> {
  // Future holding the client statement data.
  late Future<ClientStatement> _futureClientStatement;

  @override
  void initState() {
    super.initState();
    // Fetch the client statement data from the API using the client ID.
    _futureClientStatement = ApiService().fetchStatements(widget.clientID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<ClientStatement>(
        future: _futureClientStatement,
        builder: (context, snapshot) {
          // Show a loading spinner while waiting for data.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Display an error message if an error occurs.
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // Show a message if no data is available.
          else if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }
          // Build the statements view using the fetched data.
          final clientStatement = snapshot.data!;
          return _buildStatements(clientStatement);
        },
      ),
    );
  }

  /// Constructs the widget tree for displaying statements.
  /// Each month is displayed with a header followed by its transactions.
  Widget _buildStatements(ClientStatement clientStatement) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title for the statements section.
          const Text(
            'Statements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Iterate over each month's data.
          for (final monthData in clientStatement.statement) ...[
            _buildMonthHeader(monthData.month),
            const SizedBox(height: 8),
            // Iterate over each transaction within the month.
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

  /// Builds a header widget for a given month.
  /// Displays the month and year in a stylized manner.
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
