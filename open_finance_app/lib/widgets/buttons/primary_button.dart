import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A primary styled button widget for high-emphasis actions.
///
/// This widget creates a styled button with the app's primary color as background
/// and white text. It supports loading state visualization and can adapt to
/// different width requirements.
class PrimaryButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;
  
  /// Callback function that is triggered when the button is pressed.
  ///
  /// If null, the button will be disabled (non-interactive).
  final VoidCallback? onPressed;
  
  /// Whether the button is currently in a loading state.
  ///
  /// When true, the button displays a loading indicator instead of text
  /// and becomes non-interactive.
  final bool isLoading;
  
  /// Whether the button should expand to fill its parent's width.
  ///
  /// When true (default), the button takes up all available horizontal space.
  /// When false, the button sizes itself to fit its content.
  final bool fullWidth;

  /// Creates a PrimaryButton.
  ///
  /// The [text] parameter determines what text appears on the button.
  ///
  /// The [onPressed] parameter defines what happens when the button is tapped.
  /// If null, the button will be disabled.
  ///
  /// The optional [isLoading] parameter, when true, shows a loading indicator
  /// instead of the button text and disables interaction. Defaults to false.
  ///
  /// The optional [fullWidth] parameter determines if the button should take
  /// the full available width. Defaults to true.
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenHeight * 0.06; // 6% of screen height
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textSecondary,
          padding: EdgeInsets.symmetric(
            vertical: buttonHeight * 0.3,
            horizontal: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: buttonHeight * 0.4,
                width: buttonHeight * 0.4,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text),
      ),
    );
  }
}