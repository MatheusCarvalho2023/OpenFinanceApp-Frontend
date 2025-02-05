import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;

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