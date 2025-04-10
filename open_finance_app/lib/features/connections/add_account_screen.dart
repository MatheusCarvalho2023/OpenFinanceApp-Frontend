/// Screen that allows users to add a new bank account to their financial profile.
///
/// This screen presents a form where the user can enter their account number
/// to connect a new bank account to the OpenFinance system.
library;
import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/profile_home.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';
import 'package:open_finance_app/navigation/main_navigation.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/widgets/tab_menu.dart';
import 'package:open_finance_app/features/connections/connections_screen.dart';

/// A screen widget that allows users to add a new bank account connection.
///
/// This screen takes the bank ID, name, and client ID as required parameters
/// to establish a connection between the user's account and the selected bank.
class AddAccountScreen extends StatefulWidget {
  /// The unique identifier of the bank to connect to
  final int bankId;
  
  /// The display name of the bank
  final String bankName;
  
  /// The client's unique identifier
  final int clientID;

  const AddAccountScreen({
    super.key,
    required this.bankId,
    required this.bankName,
    required this.clientID,
  });

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

/// The state class for the AddAccountScreen.
class _AddAccountScreenState extends State<AddAccountScreen> {
  /// Key for the form to enable validation
  final _formKey = GlobalKey<FormState>();
  
  /// Controller for the account number text input
  final _accountNumberController = TextEditingController();
  
  /// Flag to indicate whether a network request is in progress
  bool _isLoading = false;

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  /// Validates and submits the form data to the API.
  ///
  /// This method validates the input, sends the account connection request
  /// to the backend API, and handles success or error responses.
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(ApiEndpoints.addConnection);

      final requestBody = {
        'clientID': widget.clientID,
        'bankID': widget.bankId,
        'accountNumber': _accountNumberController.text,
      };

      debugPrint('Sending request to: $url');
      debugPrint('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success message and return to previous screen
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account added successfully')),
          );
          Navigator.pop(context, true);
        }
      } else {
        // Parse error message from response if available
        String errorMsg = 'Failed to add account: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData != null && errorData['message'] != null) {
            errorMsg = errorData['message'];
          }
        } catch (e) {
          // If parsing fails, use the default error message
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error: ${e.toString().replaceAll('Exception: ', '')}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handles navigation when a bottom navigation item is tapped.
  ///
  /// [index] The index of the tapped navigation item.
  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigate to Home (TabMenu)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigation(clientID: widget.clientID),
        ),
      );
    } else if (index == 1) {
      // Navigate to Connections
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectionsScreen(clientID: widget.clientID),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileHomeScreen(),
        ),
      );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter your account number",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Account Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your account number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.textSecondary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Connect Account"),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: 1, // Set to 1 since this is related to Connections tab
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
