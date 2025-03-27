import 'package:flutter/material.dart';
import 'package:open_finance_app/features/wallet/analysis_screen.dart';
import 'package:open_finance_app/features/wallet/statements_screen.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';
import 'package:open_finance_app/features/wallet/assets_screen.dart';

/// A widget that creates a tabbed menu for navigating between different wallet screens.
/// The tabs include Summary, Assets, Analysis, and Statements.
class TabMenu extends StatelessWidget {
  /// The client ID used to fetch data in each of the wallet screens.
  final int clientID;

  /// Constructs a [TabMenu] widget with the provided client ID.
  const TabMenu({
    super.key,
    required this.clientID,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Define the total number of tabs.
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          // Display a greeting in the AppBar title.
          title: const Text(
            "Good morning, John!",
            style: TextStyle(color: AppColors.textSecondary),
          ),
          centerTitle: true,
          bottom: const TabBar(
            // Set styling for selected and unselected labels.
            labelColor: AppColors.secondaryColor,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.textSecondary,
            tabs: [
              Tab(text: "Summary"),
              Tab(text: "Assets"),
              Tab(text: "Analysis"),
              Tab(text: "Statements"),
            ],
          ),
        ),
        // Define the content for each tab.
        body: TabBarView(
          children: [
            // Each screen receives the client ID for fetching its respective data.
            SummaryScreen(clientID: clientID),
            AssetsScreen(clientID: clientID),
            AnalysisScreen(clientID: clientID),
            StatementsScreen(clientID: clientID)
          ],
        ),
      ),
    );
  }
}
