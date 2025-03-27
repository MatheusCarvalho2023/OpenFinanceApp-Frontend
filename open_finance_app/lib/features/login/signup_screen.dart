// ignore_for_file: use_build_context_synchronously, avoid_print

/// User registration screen for the OpenFinance application.
///
/// This screen provides a form for new users to create an account by
/// entering their personal information including name, address, email
/// and a secure password.
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/widgets/inputs/fullname_input_field.dart';
import 'package:open_finance_app/widgets/inputs/address_input_field.dart';
import 'package:open_finance_app/widgets/inputs/email_input_field.dart';
import 'package:open_finance_app/widgets/inputs/password_input_field.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:open_finance_app/features/wallet/summary_screen.dart';
import 'package:open_finance_app/features/login/login_screen.dart';

/// A screen widget that allows new users to register for an account.
///
/// This screen presents a form with fields for full name, address,
/// email, and password, with validation for each field.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

/// The state class for the SignupScreen.
class SignupScreenState extends State<SignupScreen> {
  /// Regular expression for password validation.
  ///
  /// Requires at least:
  /// - 8 characters
  /// - 1 uppercase letter
  /// - 1 digit
  /// - 1 special character (@, $, !, %, *, ?, &)
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  /// Regular expression for email validation.
  ///
  /// Validates standard email format with username, @ symbol, and domain.
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+',
  );

  /// Key for the form to enable validation
  final _formKey = GlobalKey<FormState>();
  
  /// Controller for the email text input
  final _emailController = TextEditingController();
  
  /// Controller for the password text input
  final _passwordController = TextEditingController();
  
  /// Controller for the full name text input
  final _fullnameController = TextEditingController();
  
  /// Controller for the address text input
  final _addressController = TextEditingController();
  
  /// Flag to indicate whether a signup request is in progress
  bool _isLoading = false;

  /// Validates form data and submits it to create a new user account.
  ///
  /// This method validates all form fields, sends the registration request
  /// to the backend API, and handles success or error responses. On successful
  /// registration, redirects the user to the SummaryScreen.
  Future<void> _signupUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse(ApiEndpoints.signup),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'name': _fullnameController.text,
            'address': _addressController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          print('Calling SummaryScreen');
          final responseData = json.decode(response.body);
          final clientID = responseData['clientID'];

          if (clientID == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Invalid response: missing clientID')),
            );
            return;
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SummaryScreen(
                clientID: clientID,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign up: ${response.body}')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error: ${error.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              // Logo Section (Upper Third)
              Flexible(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    'lib/assets/images/openfinanceapp_icon.png',
                    height: screenHeight * 0.2,
                  ),
                ),
              ),

              // Form Section
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Instructions Text
                        const Text(
                          'Please enter your details',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Fullname Input
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: FullnameInputField(
                                  controller: _fullnameController),
                            ),
                          ],
                        ),

                        // Address Input
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: AddressInputField(
                                  controller: _addressController),
                            ),
                          ],
                        ),

                        // Email Input
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: EmailInputField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!_emailRegex.hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        // Password Input
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: PasswordInputField(
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (!_passwordRegex.hasMatch(value)) {
                                    return 'Password must contain at least 8 characters,\none uppercase letter, one number and one special character';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        // Buttons Row
                        Row(
                          children: [
                            Expanded(
                                // Cancel Button
                                child: SecondaryButton(
                              text: 'Login',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                            )),
                            const SizedBox(width: 20),
                            Expanded(
                                // Continue Button
                                child: PrimaryButton(
                                    text: "Continue",
                                    onPressed: _signupUser,
                                    isLoading: _isLoading)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
