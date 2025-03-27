import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/tab_menu.dart';
import 'package:open_finance_app/features/connections/connections_screen.dart';
import 'package:open_finance_app/features/profile/profile_home.dart';

/// A widget that provides bottom navigation for the app.
/// It allows the user to switch between Home (TabMenu), Connections, and Profile screens.
class MainNavigation extends StatefulWidget {
  /// The client ID used across the different screens.
  final int clientID;

  /// Constructs a [MainNavigation] widget.
  const MainNavigation({super.key, required this.clientID});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // The index of the currently selected bottom navigation item.
  int _selectedIndex = 0;

  // List of pages corresponding to each bottom navigation item.
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Initialize the list of pages with the provided clientID.
    _pages = [
      TabMenu(clientID: widget.clientID),
      ConnectionsScreen(clientID: widget.clientID),
      const ProfileHomeScreen(),
    ];
  }

  /// Updates the selected index and refreshes the UI when a navigation item is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the currently selected page.
      body: _pages[_selectedIndex],
      // Define the bottom navigation bar.
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          // Home navigation item.
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // Connections navigation item.
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            label: 'Connections',
          ),
          // Profile navigation item.
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
