// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/api/api_endpoints.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'package:open_finance_app/widgets/inputs/email_input_field.dart';
import 'package:open_finance_app/widgets/inputs/password_input_field.dart';
import 'dart:convert';
import 'package:open_finance_app/features/wallet/summary_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
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
  bool _isLoading = false;

  Future<void> _loginUser() async {
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
                flex: 3,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Email Input
                        EmailInputField(
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

                        // Password Input
                        PasswordInputField(
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

                        // Forgot Password
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed:
                                () {}, // TODO: Implement forgot password logic
                            child: const Text('Forgot my password'),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Buttons Row
                        Row(
                          children: [
                            Expanded(
                                // Signup Button
                                child: SecondaryButton(
                              text: 'Sign Up',
                              onPressed: () {
                                // Placeholder for navigation to Sign Up screen
                              },
                            )),
                            const SizedBox(width: 20),
                            Expanded(
                                // Continue Button
                                child: PrimaryButton(
                                    text: "Continue",
                                    onPressed: _loginUser,
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
