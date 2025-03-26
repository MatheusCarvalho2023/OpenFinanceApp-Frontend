import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A button widget that represents a selectable bank connection.
///
/// This widget displays a bank with its name and optional logo in a tappable
/// container. It visually indicates selection state through color changes and
/// border styling, allowing users to select which bank they want to connect to.
class BankConnection extends StatelessWidget {
  /// The name of the bank to display.
  final String bankName;
  
  /// Optional widget to display the bank's logo.
  ///
  /// If not provided, a default bank icon will be shown instead.
  final Widget? bankLogo;
  
  /// Callback function that is triggered when the button is tapped.
  ///
  /// This function should handle selection logic, such as updating the
  /// selected bank in the parent widget's state.
  final VoidCallback onTap;
  
  /// Whether this bank is currently selected.
  ///
  /// When true, the button will be styled with the primary color background
  /// and appropriate text color to indicate selection.
  final bool isSelected;

  /// Creates a BankConnection button.
  ///
  /// The [bankName] and [onTap] parameters are required.
  ///
  /// The optional [bankLogo] parameter can be used to display the bank's logo.
  /// If not provided, a default bank icon will be shown.
  ///
  /// The optional [isSelected] parameter indicates whether this bank is currently
  /// selected, defaulting to false.
  const BankConnection({
    super.key,
    required this.bankName,
    this.bankLogo,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Bank logo placeholder
            ClipOval(
              child: Container(
                width: 50,
                height: 50,
                color: AppColors
                    .secondaryColor, // TODO: Change to transparent or background color. Works as a visual reference now
                child: bankLogo ??
                    const Icon(Icons.account_balance,
                        color: AppColors.primaryColor),
              ),
            ),
            const SizedBox(width: 16),
            // Bank name
            Expanded(
              child: Text(
                bankName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
