import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:open_finance_app/main.dart';
import 'package:open_finance_app/navigation/main_navigation.dart';
import 'package:open_finance_app/widgets/tab_menu.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';
import 'package:open_finance_app/features/wallet/assets_screen.dart';
import 'package:open_finance_app/features/wallet/analysis_screen.dart';
import 'package:open_finance_app/features/connections/connections_screen.dart';
import 'package:open_finance_app/features/profile/profile_home.dart';
import 'package:open_finance_app/services/api_service.dart';

// Mock API service to avoid real API calls
class MockApiService extends Mock implements ApiService {}

void main() {
  // Test for main app rendering
  testWidgets('App should render without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  // Test for MainNavigation
  testWidgets('MainNavigation should render with bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigation(clientID: 1),
      ),
    );
    
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(TabMenu), findsOneWidget); // First tab should be visible by default
  });

  // Test navigation bar switching
  testWidgets('Bottom navigation bar should switch between screens', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigation(clientID: 1),
      ),
    );
    
    // Should start with TabMenu
    expect(find.byType(TabMenu), findsOneWidget);
    
    // Tap on connections tab (index 1)
    await tester.tap(find.byIcon(Icons.link).first);
    await tester.pumpAndSettle();
    
    // Should now show ConnectionsScreen
    expect(find.byType(ConnectionsScreen), findsOneWidget);
    
    // Tap on profile tab (index 2)
    await tester.tap(find.byIcon(Icons.person).first);
    await tester.pumpAndSettle();
    
    // Should now show ProfileHomeScreen
    expect(find.byType(ProfileHomeScreen), findsOneWidget);
  });

  // Test TabMenu tabs
  testWidgets('TabMenu should show tabs and switch between them', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TabMenu(clientID: 1),
        ),
      ),
    );
    
    // Verify all tabs are present
    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('Assets'), findsOneWidget);
    expect(find.text('Analysis'), findsOneWidget);
    expect(find.text('Statements'), findsOneWidget);
    
    // By default, SummaryScreen should be visible
    expect(find.byType(SummaryScreen), findsOneWidget);
    
    // Tap on Assets tab
    await tester.tap(find.text('Assets'));
    await tester.pumpAndSettle();
    
    // Should now show AssetsScreen
    expect(find.byType(AssetsScreen), findsOneWidget);
    
    // Tap on Analysis tab
    await tester.tap(find.text('Analysis'));
    await tester.pumpAndSettle();
    
    // Should now show AnalysisScreen
    expect(find.byType(AnalysisScreen), findsOneWidget);
  });
}
