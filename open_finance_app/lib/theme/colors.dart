import 'package:flutter/material.dart';

/// App-wide color definitions for the OpenFinance application.
///
/// This class provides a centralized place for all color constants used
/// throughout the application to maintain visual consistency.
class AppColors {
  /// Primary brand color used for main elements like the app bar and buttons.
  static const Color primaryColor = Color(0xFF002366);
  
  /// Used for primary text content on light backgrounds.
  static const Color textPrimary = Color(0xFF333333);
  
  /// Used for text that appears on dark backgrounds.
  static const Color textSecondary = Color(0xFFF5F5F5);
  
  /// Main background color for screens and cards.
  static const Color primaryBackground = Color(0xFFFFFFFF);
  
  /// Accent color for positive indicators like success messages or growth.
  static const Color accentGreen = Color(0xFF00A86B);
  
  /// Accent color for warnings or attention indicators.
  static const Color accentYellow = Color(0xFFFFD700);
  
  /// Accent color for errors, deletions, or negative indicators.
  static const Color accentRed = Color(0xFFFF6F61);
  
  /// Used for secondary backgrounds like panels or alternate rows.
  static const Color secondaryBackground = Color(0xFFF5F5F5);
  
  /// Secondary brand color for complementary UI elements.
  static const Color secondaryColor = Color(0xFF87CEEB);

  /// Background color for cards and elevated surfaces.
  static const Color cardBackground = primaryBackground;
  
  /// Color used for dividers and separators.
  static const Color dividerColor = Colors.blueGrey;
  
  /// Color used for subtle shadows to create elevation effects.
  static const Color shadowColor = Colors.black12;

  /// Primary color at 10% intensity - very light blue.
  /// Used for subtle highlights or backgrounds.
  static const Color primaryColor10 = Color(0xFFE6EBF5);
  
  /// Primary color at 20% intensity.
  /// Used for disabled states or secondary elements.
  static const Color primaryColor20 = Color(0xFFCCD7EC);
  
  /// Primary color at 30% intensity.
  /// Used for less prominent UI elements.
  static const Color primaryColor30 = Color(0xFFB3C3E2);
  
  /// Primary color at 40% intensity.
  /// Used for chart elements or tertiary UI components.
  static const Color primaryColor40 = Color(0xFF99AFD9);
  
  /// Primary color at 50% intensity.
  /// Used for mid-emphasis UI elements.
  static const Color primaryColor50 = Color(0xFF809BCF);
  
  /// Primary color at 60% intensity.
  /// Used for medium-emphasis UI elements.
  static const Color primaryColor60 = Color(0xFF6687C6);
  
  /// Primary color at 70% intensity.
  /// Used for higher-emphasis UI elements.
  static const Color primaryColor70 = Color(0xFF4D73BC);
  
  /// Primary color at 80% intensity.
  /// Used for high-emphasis UI elements.
  static const Color primaryColor80 = Color(0xFF335FB3);
  
  /// Primary color at 90% intensity.
  /// Used for very high-emphasis UI elements.
  static const Color primaryColor90 = Color(0xFF1A4BA9);
  
  /// Base primary color at 100% intensity.
  /// Same as primaryColor, used for consistency in gradient scales.
  static const Color primaryColor100 = Color(0xFF002366);
}
