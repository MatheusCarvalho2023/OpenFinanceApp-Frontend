import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';
// import 'package:open_finance_app/features/wallet/assets_screen.dart';
// import 'package:open_finance_app/features/wallet/analysis_screen.dart';
// import 'package:open_finance_app/features/wallet/statements_screen.dart';

/// Contains a top TabBar with four tabs
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // four tabs
      child: Scaffold(
        // AppBar with a TabBar
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            "Wallet",
            style: TextStyle(color: AppColors.accent),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.text,
            indicatorColor: AppColors.accent,
            tabs: [
              Tab(text: "Summary"),
              Tab(text: "Assets"),
              Tab(text: "Analysis"),
              Tab(text: "Statements"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SummaryScreen(
              clientID: 1,
            ),
            // AssetsScreen(),
            // AnalysisScreen(),
            // StatementsScreen(),
          ],
        ),
      ),
    );
  }
}
