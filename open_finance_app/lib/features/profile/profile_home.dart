import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/base_profile_screen.dart';
import 'package:open_finance_app/features/profile/profile_myprofile.dart';
import 'package:open_finance_app/features/login/start_screen.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';

/// ProfileHomeScreen displays the main profile page with account settings options
///
/// This screen provides users with access to:
/// - My Profile section
/// - Logout functionality
///
/// Extends [BaseProfileScreen] to inherit the common navigation and UI structure
class ProfileHomeScreen extends BaseProfileScreen {
  /// Creates a ProfileHomeScreen instance
  ///
  /// The [key] parameter is passed to the parent class constructor
  const ProfileHomeScreen({super.key});

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

/// State management class for ProfileHomeScreen
///
/// Extends [BaseProfileScreenState] to inherit common profile screen behaviors
/// including navigation bar and app bar functionality
class _ProfileHomeScreenState
    extends BaseProfileScreenState<ProfileHomeScreen> {
  /// Shows a confirmation dialog for logout and handles the logout process
  ///
  /// When confirmed, navigates to the StartScreen and removes all previous routes
  /// from the navigation stack to prevent returning to authenticated screens
  ///
  /// @param context The BuildContext used for navigation and showing the dialog
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog first
                Navigator.of(context).pop();
                // Navigate to StartScreen and clear navigation history
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                  (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the inherited buildAppBar method with a personalized greeting
      appBar: buildAppBar("Good morning, John!"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section title for account settings
            const Text(
              "Account Settings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),

            // My Profile Button - navigates to the detailed profile screen
            // Uses PrimaryButton for primary actions in the design system
            PrimaryButton(
              text: "My Profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyProfileScreen(clientID: 1),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Logout Button - triggers the logout confirmation dialog
            // Uses SecondaryButton for secondary actions in the design system
            SecondaryButton(
              text: "Logout",
              onPressed: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}
