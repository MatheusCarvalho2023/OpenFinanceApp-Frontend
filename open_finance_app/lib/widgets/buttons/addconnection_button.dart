import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A circular button widget for adding a new financial connection.
///
/// This widget creates a circular button with a plus icon that allows users
/// to trigger the process of adding a new financial connection. The button uses
/// the app's primary color scheme and can be sized as needed.
class CircularAddConnectionButton extends StatelessWidget {
  /// Callback function that is triggered when the button is tapped.
  ///
  /// This function should navigate to the screen for adding a new connection
  /// or initiate whatever action is needed to start the connection process.
  final VoidCallback onTap;
  
  /// The diameter of the circular button in logical pixels.
  ///
  /// Defaults to 56.0, which is the standard size for a Material floating action button.
  final double size;

  /// Creates a CircularAddConnectionButton.
  ///
  /// The [onTap] parameter is required and specifies the action to take when
  /// the button is tapped.
  ///
  /// The optional [size] parameter can be used to customize the diameter of the button,
  /// with a default value of 56.0 logical pixels.
  const CircularAddConnectionButton({
    super.key,
    required this.onTap,
    this.size = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }
}