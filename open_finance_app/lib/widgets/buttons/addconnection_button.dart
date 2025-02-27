import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

class CircularAddConnectionButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

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