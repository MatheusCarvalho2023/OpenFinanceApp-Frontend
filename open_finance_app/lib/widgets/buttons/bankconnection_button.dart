import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

class BankConnection extends StatelessWidget {
  final String bankName;
  final Widget? bankLogo;
  final VoidCallback onTap;
  final bool isSelected;

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
