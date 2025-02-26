import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';
import 'package:open_finance_app/features/wallet/assets_screen.dart';

class TabMenu extends StatelessWidget {
  final int clientID;

  const TabMenu({
    super.key,
    required this.clientID,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            "Good morning, John!",
            style: TextStyle(color: AppColors.textSecondary),
          ),
          centerTitle: true,
          bottom: const TabBar(
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
        body: TabBarView(
          children: [
            SummaryScreen(clientID: clientID),
            AssetsScreen(clientID: clientID),
            // AnalysisScreen() // se existir
            // StatementsScreen() // se existir
            Container(), // placeholder
            Container(), // placeholder
          ],
        ),
      ),
    );
  }
}
