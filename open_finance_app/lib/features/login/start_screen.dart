// ignore_for_file: use_build_context_synchronously, avoid_print

/// Initial landing screen for the OpenFinance application.
///
/// This screen serves as the application's entry point, displaying the app logo
/// and providing navigation options for users to either sign up for a new account
/// or log in to an existing one.
import 'package:flutter/material.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:open_finance_app/features/login/signup_screen.dart';
import 'package:open_finance_app/features/login/login_screen.dart';

/// A screen widget that serves as the initial landing page of the application.
///
/// This widget displays the OpenFinance logo and provides buttons for users
/// to navigate to either the signup screen or login screen. It's typically
/// the first screen users see when launching the application.
class StartScreen extends StatefulWidget {
  /// Creates a StartScreen instance.
  const StartScreen({super.key});

  @override
  StartScreenState createState() => StartScreenState();
}

/// The state class for the StartScreen.
///
/// Manages the UI layout and navigation logic for the initial landing page.
class StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    /// Calculate the screen height for responsive layout
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: screenHeight,
        child: Column(children: [
          // Logo Section
          Flexible(
            flex: 4,
            child: Center(
              child: Image.asset(
                'lib/assets/images/openfinanceapp_icon.png',
                height: screenHeight * 0.2,
              ),
            ),
          ),

          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Buttons Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                          // Signup Button
                          child: SecondaryButton(
                        text: 'Signup',
                        onPressed: () {
                          /// Navigate to the signup screen when the signup button is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                      )),
                      const SizedBox(width: 20),
                      Expanded(
                        // Login Button
                        child: PrimaryButton(
                            text: "Login",
                            onPressed: () {
                              /// Navigate to the login screen when the login button is pressed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    ));
  }
}
