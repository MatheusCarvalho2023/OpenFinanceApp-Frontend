import 'package:flutter/material.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/bankconnection_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
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
  int _selectedIndex = 1;
  int? _selectedBankIndex;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredBanks = [];
  List<Map<String, dynamic>> _banks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBanks();
    _searchController.addListener(_filterBanks);
  }

  Future<void> fetchBanks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(ApiEndpoints.banks);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> banksJson = jsonDecode(response.body);

        setState(() {
          _banks = banksJson
              .map((bank) => {
                    'name': bank['bankName'] ?? 'Unknown Bank',
                    'logo': bank['logo'],
                    'bankID': bank['bankID'],
                  })
              .toList();
          _filteredBanks = List.from(_banks);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load banks: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        // If API fails, provide fallback data
        _banks = [
          {'name': 'Royal Bank of Canada', 'logo': null, 'bankID': 3},
          {'name': 'TD Bank', 'logo': null, 'bankID': 1},
          {'name': 'Scotiabank', 'logo': null, 'bankID': 2},
        ];
        _filteredBanks = List.from(_banks);
      });
      debugPrint('Error fetching banks: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filters the banks based on the search query
  void _filterBanks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBanks = _banks
          .where(
              (bank) => bank['name'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const SummaryScreen(clientID: 1)),
        );
      } else if (index == 2) {
        Container(color: Colors.green); // TODO: Implement Profile screen
      }
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
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for your bank...',
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.primaryColor),
                filled: true,
                fillColor: AppColors.primaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          _isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredBanks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) => BankConnection(
                      bankName: _filteredBanks[index]['name'],
                      bankLogo: _filteredBanks[index]['logo'],
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
                    ? () async {
                        final selectedBank =
                            _filteredBanks[_selectedBankIndex!];
                        final bankId = selectedBank['bankID'] as int;
                        final bankName = selectedBank['name'] as String;

                        debugPrint(
                            'Connecting to bank: $bankName, bankID: $bankId');

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAccountScreen(
                              bankId: bankId,
                              bankName: bankName,
                              clientID: widget.clientID,
                            ),
                          ),
                        );

                        if (result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Account added successfully')),
                          );
                          Navigator.pop(context, true);
                        }
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
