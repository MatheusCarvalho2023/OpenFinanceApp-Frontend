// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:open_finance_app/widgets/inputs/address_input_field.dart';
import 'package:open_finance_app/widgets/inputs/email_input_field.dart';
import 'package:open_finance_app/widgets/inputs/fullname_input_field.dart';
import 'dart:convert';
import 'package:open_finance_app/features/wallet/summary_screen.dart';
import 'package:open_finance_app/widgets/inputs/password_input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+',
  );

  final _formKey = GlobalKey<
      FormState>(); // https://docs.flutter.dev/cookbook/forms/validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  // TODO: Implement the signupUser method
  Future<void> _signupUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse(ApiEndpoints.login),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          print('Calling SummaryScreen');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SummaryScreen(clientID: 1),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${response.body}')),
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
                              text: 'Cancel',
                              onPressed: () {
                                // TODO: Placeholder for navigation to go back to the previous screen
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
    super.dispose();
  }
}
