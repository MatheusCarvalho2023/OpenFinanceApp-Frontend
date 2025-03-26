import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A secondary styled button widget for medium-emphasis actions.
///
/// This widget creates a styled button with the app's secondary color as background
/// and primary color text. It's used for actions that are important but not the
/// primary action in a view.
class SecondaryButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;
  
  /// Callback function that is triggered when the button is pressed.
  final VoidCallback onPressed;
  
  /// Whether the button should expand to fill its parent's width.
  ///
  /// When true (default), the button takes up all available horizontal space.
  /// When false, the button sizes itself to fit its content.
  final bool fullWidth;

  /// Creates a SecondaryButton.
  ///
  /// The [text] parameter determines what text appears on the button.
  ///
  /// The [onPressed] parameter defines what happens when the button is tapped.
  ///
  /// The optional [fullWidth] parameter determines if the button should take
  /// the full available width. Defaults to true.
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    /// Calculate the button height proportional to screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenHeight * 0.06; // 6% of screen height

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(
            vertical: buttonHeight * 0.3,
            horizontal: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
