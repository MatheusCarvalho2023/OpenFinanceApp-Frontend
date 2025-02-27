import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/bankconnection_button.dart';

class AddConnectionScreen extends StatefulWidget {
  const AddConnectionScreen({super.key});

  @override
  State<AddConnectionScreen> createState() => _AddConnectionScreenState();
}

class _AddConnectionScreenState extends State<AddConnectionScreen> {
  int _selectedIndex = 1;
  int? _selectedBankIndex;

  // Sample bank data TODO: Replace with dynamic bank data from API
  final List<Map<String, dynamic>> _banks = [
    {'name': 'Royal Bank of Canada', 'logo': null},
    {'name': 'TD Bank', 'logo': null},
    {'name': 'Scotiabank', 'logo': null},
    {'name': 'CIBC', 'logo': null},
    {'name': 'BMO', 'logo': null},
    {'name': 'Wealthsimple', 'logo': null},
    {'name': 'Questrade', 'logo': null},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: Implement navigation
    });
  }

  void _selectBank(int index) {
    setState(() {
      _selectedBankIndex = _selectedBankIndex == index ? null : index;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _banks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) => BankConnection(
                bankName: _banks[index]['name'],
                bankLogo: _banks[index]['logo'],
                isSelected: _selectedBankIndex == index,
                onTap: () => _selectBank(index),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedBankIndex != null
                    ? () {
                        // TODO: Handle connection to the selected bank
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.textSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Connect"),
              ),
            ),
          ),
        ],
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
