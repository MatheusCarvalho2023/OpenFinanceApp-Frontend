import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/profile_home.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/inputs/password_input_field.dart';

/// A screen that allows users to change their password and manage security settings.
///
/// This screen provides form fields for entering an existing password and a new password,
/// as well as buttons to submit or cancel the password change operation.
class MySecurityScreen extends StatefulWidget {
  const MySecurityScreen({super.key});

  @override
  State<MySecurityScreen> createState() => _MySecurityScreenState();
}

class _MySecurityScreenState extends State<MySecurityScreen> {
  int _selectedIndex = 2;
  
  /// Controller for the old password input field.
  final _oldPasswordController = TextEditingController();
  
  /// Controller for the new password input field.
  final _newPasswordController = TextEditingController();

  /// Handles the bottom navigation bar item selection.
  ///
  /// Updates the selected index when a navigation tab is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: Implement navigation
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Password & Security",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 30),

            // Old Password input field with validation
            PasswordInputField(
              controller: _oldPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your old password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // New Password input field with validation
            PasswordInputField(
              controller: _newPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your new password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Action buttons for canceling or confirming the password change
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: SecondaryButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileHomeScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // Submit Button
                Expanded(
                  child: PrimaryButton(
                    text: 'Confirm Password',
                    onPressed: () {
                      // TODO: Implement save changes functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Changes saved successfully')),
                      );
                    },
                  ),
                ),
              ],
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
