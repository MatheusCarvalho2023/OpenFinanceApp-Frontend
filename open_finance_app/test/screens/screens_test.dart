import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import all the screen widgets to be tested.
import 'package:open_finance_app/features/wallet/analysis_screen.dart';
import 'package:open_finance_app/features/wallet/assets_details_screen.dart';
import 'package:open_finance_app/features/wallet/assets_screen.dart';
import 'package:open_finance_app/features/wallet/statements_screen.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';

/// Group of widget tests for verifying that each screen in the OpenFinance App
/// renders the expected initial UI elements, such as loading indicators, titles,
/// form fields, and navigation buttons.
void main() {
  group('Screen Widget Tests', () {
    // ---------------------------
    // Test AnalysisScreen
    // ---------------------------
    testWidgets('AnalysisScreen shows two loading indicators initially',
        (WidgetTester tester) async {
      // Pump the AnalysisScreen wrapped in a MaterialApp to provide context.
      await tester
          .pumpWidget(const MaterialApp(home: AnalysisScreen(clientID: 1)));

      // Expect two CircularProgressIndicators (one for each FutureBuilder).
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });

    // ---------------------------
    // Test AssetsDetailsScreen
    // ---------------------------
    testWidgets('AssetsDetailsScreen displays correct AppBar title',
        (WidgetTester tester) async {
      // Pump the AssetsDetailsScreen with a sample product name.
      await tester.pumpWidget(const MaterialApp(
        home: AssetsDetailsScreen(clientID: 1, productName: "Stock"),
      ));
      // Verify that the AppBar title contains the expected text.
      expect(find.text("Stock details"), findsOneWidget);
    });

    // ---------------------------
    // Test AssetsScreen
    // ---------------------------
    testWidgets('AssetsScreen shows loading indicator initially',
        (WidgetTester tester) async {
      // Pump the AssetsScreen.
      await tester
          .pumpWidget(const MaterialApp(home: AssetsScreen(clientID: 1)));
      // Expect a loading spinner initially.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // ---------------------------
    // Test StatementsScreen
    // ---------------------------
    testWidgets('StatementsScreen shows loading indicator initially',
        (WidgetTester tester) async {
      // Pump the StatementsScreen.
      await tester
          .pumpWidget(const MaterialApp(home: StatementsScreen(clientID: 1)));
      // Expect a CircularProgressIndicator until data is loaded.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // ---------------------------
    // Test SummaryScreen
    // ---------------------------
    testWidgets('SummaryScreen shows loading indicator initially',
        (WidgetTester tester) async {
      // Pump the SummaryScreen.
      await tester
          .pumpWidget(const MaterialApp(home: SummaryScreen(clientID: 1)));
      // Expect a CircularProgressIndicator while waiting for summary data.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
