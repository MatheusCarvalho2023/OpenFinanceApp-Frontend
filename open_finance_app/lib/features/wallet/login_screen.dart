import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_finance_app/theme/colors.dart';
import 'package:open_finance_app/widgets/buttons/primary_button.dart';
import 'package:open_finance_app/widgets/buttons/secondary_button.dart';
import 'dart:convert';

import 'package:open_finance_app/widgets/inputs/email_input_field.dart';
import 'package:open_finance_app/widgets/inputs/password_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // https://docs.flutter.dev/cookbook/forms/validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse(
              'ENDPOINT_URL_HERE'), // TODO: Replace with Fernando's endpoint
          body: {
            'email': _emailController.text,
            'password': _passwordController.text,
          },
        );

        final responseData = json.decode(response.body);

        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/WalletScreen');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.toString()}')),
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
                        EmailInputField(controller: _emailController),

                        // Password Input
                        PasswordInputField(controller: _passwordController),

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
