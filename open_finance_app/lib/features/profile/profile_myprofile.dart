import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: Implement navigation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Good morning, John!",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Profile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 30),

            // Name
            // TODO: Implement text editing controller
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'John Smith',
                prefixIcon:
                    const Icon(Icons.person, color: AppColors.primaryColor),
                filled: true,
                fillColor: AppColors.primaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Address
            // TODO: Implement text editing controller
            TextField(
              decoration: InputDecoration(
                labelText: 'Address',
                hintText: '1 Cupertino Loop',
                prefixIcon:
                    const Icon(Icons.home, color: AppColors.primaryColor),
                filled: true,
                fillColor: AppColors.primaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            // TODO: Implement text editing controller
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'john@doe.com',
                prefixIcon:
                    const Icon(Icons.email, color: AppColors.primaryColor),
                filled: true,
                fillColor: AppColors.primaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Buttons Row
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: SecondaryButton(
                    text: 'Cancel',
                    onPressed: () {
                      // TODO: Implement navigation to profile home
                    },
                  ),
                ),
                const SizedBox(width: 16),
                
                // Submit Button
                Expanded(
                  child: PrimaryButton(
                    text: 'Update',
                    onPressed: () {
                      // TODO: Implement save changes functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Changes saved successfully')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
