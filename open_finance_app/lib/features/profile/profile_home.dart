import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/profile_myprofile.dart';
import 'package:open_finance_app/features/start_screen.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({super.key});

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: Implement navigation
    });
  }

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
