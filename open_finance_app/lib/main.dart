import 'package:flutter/material.dart';
import 'package:open_finance_app/navigation/main_navigation.dart';
// import 'package:open_finance_app/features/wallet/login_screen.dart';
// import 'package:open_finance_app/features/wallet/wallet_screen.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenFinance App',
      theme: ThemeData(
        // Theme colors
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.secondaryBackground,
      ),
      // home: const LoginScreen(),
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
