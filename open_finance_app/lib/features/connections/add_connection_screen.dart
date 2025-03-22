import 'package:flutter/material.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/models/bank_model.dart';
import 'package:open_finance_app/services/bank_service.dart';
import 'package:open_finance_app/widgets/bank_list.dart';
import 'package:open_finance_app/features/connections/add_account_screen.dart';

class AddConnectionScreen extends StatefulWidget {
  final int clientID;

  const AddConnectionScreen({
    super.key,
    required this.clientID,
  });

  @override
  State<AddConnectionScreen> createState() => _AddConnectionScreenState();
}

class _AddConnectionScreenState extends State<AddConnectionScreen> {
  final _bankService = BankService();
  int _selectedIndex = 1;
  int? _selectedBankIndex;
  final TextEditingController _searchController = TextEditingController();
  List<Bank> _allBanks = [];
  List<Bank> _filteredBanks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBanks();
    _searchController.addListener(_filterBanks);
  }

  Future<void> _loadBanks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final banks = await _bankService.fetchBanks();
      
      setState(() {
        _allBanks = banks;
        _filteredBanks = List.from(banks);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading banks: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBanks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBanks = _allBanks
          .where((bank) => bank.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SummaryScreen(clientID: 1)),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile screen not yet implemented')),
      );
    }
  }

  void _selectBank(int index) {
    setState(() {
      _selectedBankIndex = _selectedBankIndex == index ? null : index;
    });
  }

  Future<void> _connectToSelectedBank() async {
    if (_selectedBankIndex == null) return;
    
    final selectedBank = _filteredBanks[_selectedBankIndex!];
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAccountScreen(
          bankId: selectedBank.bankId,
          bankName: selectedBank.name,
          clientID: widget.clientID,
        ),
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account added successfully')),
      );
      Navigator.pop(context, true);
    }
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
          _buildSearchBar(),
          _isLoading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: BankList(
                    banks: _filteredBanks,
                    selectedBankIndex: _selectedBankIndex,
                    onBankSelected: _selectBank,
                  ),
                ),
          _buildConnectButton(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for your bank...',
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
          filled: true,
          fillColor: AppColors.primaryBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildConnectButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selectedBankIndex != null ? _connectToSelectedBank : null,
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
    );
  }

  Widget _buildBottomNavigationBar() {
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
}
