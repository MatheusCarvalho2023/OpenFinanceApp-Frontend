import 'package:flutter/material.dart';
import 'package:open_finance_app/features/login/login_screen.dart';
import 'package:open_finance_app/theme/colors.dart';

/// The entry point of the OpenFinance App.
/// It initializes the application by running [MyApp].
void main() async {
  runApp(const MyApp());
}

/// The root widget of the application.
/// Sets up the global theme and initial screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The title of the application.
      title: 'OpenFinance App',
      // Define the theme for the app using the custom colors.
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.secondaryBackground,
      ),
      // Set the initial screen to the login screen.
      home: const LoginScreen(),
      // Hide the debug banner in the top-right corner.
      debugShowCheckedModeBanner: false,
    );
  }
}
