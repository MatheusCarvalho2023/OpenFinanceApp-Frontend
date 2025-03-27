import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/base_profile_screen.dart';
import 'package:open_finance_app/features/profile/profile_home.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/inputs/password_input_field.dart';

/// MySecurityScreen allows users to update their account password
///
/// This screen provides a simple form for users to:
/// - Enter their current password for verification
/// - Set a new password for their account
/// - Submit password changes
///
/// Extends [BaseProfileScreen] to inherit the common navigation and UI structure
class MySecurityScreen extends BaseProfileScreen {
  /// Creates a MySecurityScreen instance
  ///
  /// The [key] parameter is passed to the parent class constructor
  const MySecurityScreen({super.key});

  @override
  State<MySecurityScreen> createState() => _MySecurityScreenState();
}

/// State management class for MySecurityScreen
///
/// Extends [BaseProfileScreenState] to inherit common profile screen behaviors
/// including navigation bar and app bar functionality
class _MySecurityScreenState extends BaseProfileScreenState<MySecurityScreen> {
  /// Controller for the old password input field
  /// Used to access and validate the current password entered by the user
  final _oldPasswordController = TextEditingController();
  
  /// Controller for the new password input field
  /// Used to access and validate the new password entered by the user
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the text controllers to avoid memory leaks
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  /// Validates and updates the user's password
  ///
  /// This method should implement password validation and API calls
  /// to update the user's password on the backend
  /// Currently shows a success message as a placeholder
  void _updatePassword() {
    // TODO: Implement actual password update logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the inherited appBar with consistent styling
      appBar: buildAppBar("Good morning, John!"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security section header
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
            // Uses custom PasswordInputField widget for consistency and security
            PasswordInputField(
              controller: _oldPasswordController,
              hintText: 'Current Password',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your old password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // New Password input field with validation
            // Uses custom PasswordInputField widget for consistency and security
            PasswordInputField(
              controller: _newPasswordController,
              hintText: 'New Password',
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
                // Cancel Button - returns to profile home without saving changes
                Expanded(
                  child: SecondaryButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileHomeScreen()
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // Submit Button - triggers password update process
                Expanded(
                  child: PrimaryButton(
                    text: 'Update Password',
                    onPressed: _updatePassword,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
