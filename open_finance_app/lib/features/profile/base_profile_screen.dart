import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/profile_home.dart';
import 'package:open_finance_app/theme/colors.dart';

/// Base abstract class for all profile related screens
/// 
/// This widget serves as the foundation for all profile-related screens,
/// enforcing a consistent structure and navigation pattern.
abstract class BaseProfileScreen extends StatefulWidget {
  const BaseProfileScreen({super.key});
}

/// Base state class for all profile screen states
/// 
/// Provides common functionality for profile screens including:
/// - Bottom navigation bar with routing logic
/// - Common AppBar with consistent styling
/// - Navigation handling between different app sections
/// 
/// Type parameter [T] ensures proper state-widget relationship
abstract class BaseProfileScreenState<T extends BaseProfileScreen> extends State<T> {
  /// Fixed index for the profile tab in the bottom navigation bar
  /// Profile is always at index 2
  final int _selectedIndex = 2;
  
  /// Handles navigation when a bottom bar item is tapped
  /// 
  /// If the tapped item is the current item, no action is taken
  /// Otherwise, navigates to the appropriate screen based on index:
  /// - 0: Home screen
  /// - 1: Connections screen
  /// - 2: Profile screen
  /// 
  /// @param index The index of the tapped navigation item
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    switch (index) {
      case 0:
        // Navigate to Home screen
        // TODO: Replace with actual home navigation
        break;
      case 1:
        // Navigate to Connections screen
        // TODO: Replace with actual connections navigation
        break;
      case 2:
        // Only navigate to profile if not already on profile home
        // Prevents unnecessary rebuilds
        if (this.runtimeType.toString() != '_ProfileHomeScreenState') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileHomeScreen()),
          );
        }
        break;
    }
  }
  
  /// Builds the common bottom navigation bar with consistent styling
  /// 
  /// Creates a BottomNavigationBar with three fixed items:
  /// - Home (index 0)
  /// - Connections (index 1)
  /// - Profile (index 2)
  /// 
  /// @return A styled BottomNavigationBar widget
  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: AppColors.primaryColor,
      selectedItemColor: AppColors.secondaryColor,
      unselectedItemColor: AppColors.textSecondary,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.link),
          label: 'Connections',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
  
  /// Builds a standardized AppBar for profile screens
  /// 
  /// Creates an AppBar with consistent styling across all profile screens
  /// 
  /// @param title The title text to display in the AppBar
  /// @return A styled AppBar widget
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