import 'package:flutter/material.dart';
import 'package:open_finance_app/navigation/main_navigation.dart';
import 'package:open_finance_app/theme/colors.dart';

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
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.secondary,
      ),
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
