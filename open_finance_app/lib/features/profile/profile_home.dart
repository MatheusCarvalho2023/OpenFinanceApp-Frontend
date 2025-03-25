import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/profile_myprofile.dart';
import 'package:open_finance_app/features/start_screen.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A screen that displays account settings and options for the user profile.
///
/// This screen provides options for navigating to the user profile details
/// screen and logging out of the application.
class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({super.key});

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  int _selectedIndex = 2;

  /// Handles the navigation bar item selection.
  ///
  /// When a bottom navigation tab is tapped, this updates the selected index.
  /// TODO: Implement actual navigation to the corresponding screens.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: Implement navigation
    });
  }

  /// Shows a confirmation dialog for logout and handles the logout process.
  ///
  /// This method displays an AlertDialog that asks the user to confirm
  /// their intention to log out. If confirmed, it clears user data and
  /// navigates to the StartScreen.
  void _handleLogout(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _clearUserData();

                Navigator.of(context).pop();
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

  /// Clears all user data from SharedPreferences.
  ///
  /// This method is called when the user logs out to ensure
  /// that no user data remains stored on the device.
  void _clearUserData() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });

    debugPrint("User data cleared");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Good morning, John!",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Account Settings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            // My Profile Button
            PrimaryButton(
              text: "My Profile",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyProfileScreen(clientID: 1)),
                );
              },
            ),
            const SizedBox(height: 16),
            // Logout Button
            SecondaryButton(
              text: "Logout",
              onPressed: () {
                _handleLogout(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            label: 'Connections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
