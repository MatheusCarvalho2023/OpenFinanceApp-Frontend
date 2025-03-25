import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/profile_home.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/models/client_model.dart';
import 'package:open_finance_app/api/api_endpoints.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// A screen that allows users to view and edit their profile information.
///
/// This screen fetches and displays the user's profile data including name,
/// email, and address. It also provides functionality to update this information.
class MyProfileScreen extends StatefulWidget {
  /// The unique identifier for the client.
  ///
  /// This ID is required to fetch the user's profile data from the backend.
  final int clientID;

  const MyProfileScreen({super.key, required this.clientID});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  int _selectedIndex = 2;
  bool _isLoading = true;

  // Text controllers for the form fields
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();

  /// Client data model containing user information.
  late Client _clientData;

  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Loads client data from the API and populates the form fields.
  ///
  /// This method is called during initialization to fetch the client's
  /// profile data from the backend API. It updates the form fields with
  /// the fetched data once available.
  Future<void> _loadClientData() async {
    try {
      final client = await _fetchClientData(widget.clientID);
      setState(() {
        _clientData = client;
        _nameController.text = client.clientName ?? '';
        _addressController.text = client.clientAddress ?? '';
        _emailController.text = client.clientEmail ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    }
  }

  /// Fetches client data from the backend API.
  ///
  /// [clientID] The unique identifier for the client.
  ///
  /// Returns a [Client] object containing the client's profile information.
  /// Throws an exception if the API request fails.
  Future<Client> _fetchClientData(int clientID) async {
    final url = Uri.parse(ApiEndpoints.getClientData(clientID));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load client data');
    }
  }

  /// Updates the client's profile information on the backend.
  ///
  /// This method collects the modified fields from the form, sends a PATCH
  /// request to the API, and updates the local client data if successful.
  /// Shows appropriate feedback messages based on the result.
  Future<void> _updateClientProfile() async {
    setState(() => _isLoading = true);

    try {
      // Create a map with only the clientID initially
      final Map<String, dynamic> updatedFields = {
        'clientID': widget.clientID,
      };

      // Add fields only if they've been changed
      if (_nameController.text != _clientData.clientName) {
        updatedFields['clientName'] = _nameController.text;
      }

      if (_addressController.text != _clientData.clientAddress) {
        updatedFields['clientAddress'] = _addressController.text;
      }

      if (_emailController.text != _clientData.clientEmail) {
        updatedFields['clientEmail'] = _emailController.text;
      }

      // If nothing was changed, show message and return early
      if (updatedFields.length == 1) {
        // Only contains clientID
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes detected')),
        );
        return;
      }

      final url = Uri.parse(ApiEndpoints.updateClientData());
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedFields),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        // Update local client data with the new values
        _clientData = Client(
          clientId: widget.clientID,
          clientName: _nameController.text,
          clientEmail: _emailController.text,
          clientAddress: _addressController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// Handles the bottom navigation bar item selection.
  ///
  /// Updates the selected index when a navigation tab is tapped.
  /// TODO: Implement actual navigation to the corresponding screens.
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(Icons.person,
                          color: AppColors.primaryColor),
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
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      hintText: 'Enter your address',
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
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Your email address',
                      prefixIcon: const Icon(Icons.email,
                          color: AppColors.primaryColor),
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileHomeScreen()));
                          },
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Submit Button
                      Expanded(
                        child: PrimaryButton(
                          text: 'Update',
                          onPressed: () {
                            _updateClientProfile();
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
