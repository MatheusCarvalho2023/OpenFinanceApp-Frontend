import 'package:flutter/material.dart';
import 'package:open_finance_app/features/profile/base_profile_screen.dart';
import 'package:open_finance_app/features/profile/profile_home.dart';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/models/client_model.dart';
import 'package:open_finance_app/api/api_endpoints.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// MyProfileScreen displays and allows editing of user profile information
///
/// This screen provides a form for users to:
/// - View their current profile details
/// - Update their name, address, and email
/// - Save changes to the backend API
///
/// Extends [BaseProfileScreen] to inherit the common navigation and UI structure
class MyProfileScreen extends BaseProfileScreen {
  /// The unique identifier for the client whose profile is being displayed
  final int clientID;

  /// Creates a MyProfileScreen instance
  ///
  /// The [clientID] parameter is required to fetch the correct client data
  /// The [key] parameter is passed to the parent class constructor
  const MyProfileScreen({super.key, required this.clientID});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

/// State management class for MyProfileScreen
///
/// Extends [BaseProfileScreenState] to inherit common profile screen behaviors
/// including navigation bar and app bar functionality
class _MyProfileScreenState extends BaseProfileScreenState<MyProfileScreen> {
  /// Indicates whether data is currently being loaded or saved
  bool _isLoading = true;

  /// Text controllers for the form fields
  /// Used to access and update the text input values
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();

  /// Client data model containing user information
  /// Stores the original data fetched from the API
  late Client _clientData;

  @override
  void initState() {
    super.initState();
    // Load client data when the widget initializes
    _loadClientData();
  }

  @override
  void dispose() {
    // Dispose of the text controllers to avoid memory leaks
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Loads client data from the API and populates the form fields
  ///
  /// Fetches the client information using the client ID and updates the UI
  /// Shows error message if data fetching fails
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
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    }
  }

  /// Fetches client data from the backend API
  ///
  /// Makes an HTTP GET request to the client data endpoint
  /// Parses the JSON response into a Client object
  ///
  /// @param clientID The ID of the client to fetch
  /// @return A Future containing the Client object with profile data
  /// @throws Exception if the API request fails
  Future<Client> _fetchClientData(int clientID) async {
    final url = Uri.parse(ApiEndpoints.getClientData(clientID));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load client data');
    }
  }

  /// Updates the client's profile information on the backend
  ///
  /// Compares form values with original data to identify changes
  /// Sends only modified fields to the API to minimize data transfer
  /// Shows appropriate feedback messages based on the operation result
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
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes detected')),
        );
        return;
      }

      final url = Uri.parse(ApiEndpoints.updateClientData());
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the inherited appBar with consistent styling
      appBar: buildAppBar("Good morning, John!"),

      // Show loading indicator while fetching data
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile section header
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Name input field
                  // Uses consistent styling with person icon
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

                  // Address input field
                  // Uses consistent styling with home icon
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

                  // Email input field
                  // Uses consistent styling with email icon
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

                  // Action buttons row
                  // Provides Cancel and Update options
                  Row(
                    children: [
                      // Cancel Button - returns to profile home
                      Expanded(
                        child: SecondaryButton(
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfileHomeScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Update Button - saves profile changes
                      Expanded(
                        child: PrimaryButton(
                          text: 'Update',
                          onPressed: () => _updateClientProfile(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
