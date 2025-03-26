import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A custom input field for collecting user email addresses.
///
/// This widget provides a styled text field specifically designed for email input
/// with appropriate keyboard type, icon, and styling to match the application's design
/// language. It supports custom validation through an optional validator function.
class EmailInputField extends StatelessWidget {
  /// Controller for the text field to access or modify the email input.
  ///
  /// This controller allows parent widgets to read the current email value
  /// or set it programmatically.
  final TextEditingController controller;
  
  /// Optional custom validation function for the email input.
  ///
  /// If provided, this function will be called when the form containing this field
  /// is validated. It should return an error message string if validation fails,
  /// or null if the email is valid.
  ///
  /// If not provided, the field will only use basic form validation without
  /// specific email format checking.
  final String? Function(String?)? validator;

  /// Creates an EmailInputField widget.
  ///
  /// The [controller] parameter is required and will be used to control the text
  /// input and access its value.
  ///
  /// The optional [validator] parameter can be used to provide custom email
  /// validation logic. If not provided, the field will only use basic form validation.
  const EmailInputField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        cursorColor: AppColors.primaryColor,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(color: AppColors.textPrimary, fontSize: 16),
          prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
          filled: true,
          fillColor: AppColors.primaryBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(color: AppColors.accentRed),
        ),
        validator: validator,
      ),
    );
  }
}
