/// Screen that allows users to add a new financial connection.
///
/// This screen displays a list of available banks that users can connect to
/// their OpenFinance account. Users can search for specific banks and select
/// one to establish a new connection.
import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/profile_home.dart';
import 'package:open_finance_app/navigation/main_navigation.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/models/bank_model.dart';
import 'package:open_finance_app/services/bank_service.dart';
import 'package:open_finance_app/widgets/bank_list.dart';
import 'package:open_finance_app/features/connections/add_account_screen.dart';

/// A screen widget that allows users to browse and select a bank to connect.
///
/// This screen presents a searchable list of supported banks and provides
/// a way for users to establish a new financial connection with their selected bank.
class AddConnectionScreen extends StatefulWidget {
  /// The unique identifier of the client adding a connection
  final int clientID;

  const AddConnectionScreen({
    super.key,
    required this.clientID,
  });

  @override
  State<AddConnectionScreen> createState() => _AddConnectionScreenState();
}

/// The state class for the AddConnectionScreen.
class _AddConnectionScreenState extends State<AddConnectionScreen> {
  /// Service for fetching bank data from the API
  final _bankService = BankService();

  /// Index for the bottom navigation bar
  int _selectedIndex = 1;

  /// Index of the currently selected bank in the list
  int? _selectedBankIndex;

  /// Controller for the search text input
  final TextEditingController _searchController = TextEditingController();

  /// Complete list of available banks
  List<Bank> _allBanks = [];

  /// Filtered list of banks based on search query
  List<Bank> _filteredBanks = [];

  /// Flag to indicate whether data is being loaded
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBanks();
    _searchController.addListener(_filterBanks);
  }

  /// Fetches the list of available banks from the API.
  ///
  /// Updates the state with the fetched banks or displays an error message
  /// if the request fails.
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

  /// Displays an error message to the user.
  ///
  /// [message] The error message to display.
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

  /// Filters the bank list based on the current search query.
  ///
  /// This method is called whenever the search text changes.
  void _filterBanks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBanks = _allBanks
          .where((bank) => bank.name.toLowerCase().contains(query))
          .toList();
    });
  }

  /// Handles navigation when a bottom navigation item is tapped.
  ///
  /// [index] The index of the tapped navigation item.
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MainNavigation(clientID: 1)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileHomeScreen()),
      );
    }
  }

  /// Updates the selected bank when a user taps on a bank in the list.
  ///
  /// [index] The index of the selected bank in the filtered list.
  void _selectBank(int index) {
    setState(() {
      _selectedBankIndex = _selectedBankIndex == index ? null : index;
    });
  }

  /// Navigates to the account connection screen for the selected bank.
  ///
  /// This method is called when the user taps the Connect button after
  /// selecting a bank from the list.
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
      // ignore: use_build_context_synchronously
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
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _isLoading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
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

  /// Builds the search input field for filtering banks.
  ///
  /// Returns a styled TextField widget with search functionality.
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

  /// Builds the connect button for proceeding with bank connection.
  ///
  /// Returns a styled button that's enabled only when a bank is selected.
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

  /// Builds the bottom navigation bar for the screen.
  ///
  /// Returns a BottomNavigationBar with Home, Connections, and Profile tabs.
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
