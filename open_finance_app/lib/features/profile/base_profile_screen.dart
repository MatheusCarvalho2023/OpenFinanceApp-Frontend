import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// Base abstract class for all profile related screens
abstract class BaseProfileScreen extends StatefulWidget {
  const BaseProfileScreen({super.key});
}

/// Base state class for all profile screen states
abstract class BaseProfileScreenState<T extends BaseProfileScreen> extends State<T> {
  /// Builds a standardized AppBar for profile screens
  AppBar buildAppBar(String title) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      centerTitle: true,
    );
  }
}