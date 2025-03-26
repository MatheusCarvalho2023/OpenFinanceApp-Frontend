import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A button widget for adding a new financial connection.
///
/// This widget creates a full-width button with a plus icon and text that allows users
/// to trigger the process of adding a new financial connection. The button uses
/// the app's primary color scheme and has rounded corners to match the app's design.
class AddConnectionButton extends StatelessWidget {
  /// Callback function that is triggered when the button is tapped.
  ///
  /// This function should navigate to the screen for adding a new connection
  /// or initiate whatever action is needed to start the connection process.
  final VoidCallback onTap;

  /// Creates an AddConnectionButton.
  ///
  /// The [onTap] parameter is required and specifies the action to take when
  /// the button is tapped, typically navigating to the add connection flow.
  const AddConnectionButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primaryBackground),
            SizedBox(width: 8),
            Text(
              "Add New Connection",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

