import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A custom input field for collecting user full name information.
///
/// This widget provides a styled text field specifically designed for name input
/// with appropriate validation, icon, and styling to match the application's design
/// language. It validates that the name contains only letters and spaces, meets
/// minimum length requirements, and is not empty.
class FullnameInputField extends StatefulWidget {
  /// Controller for the text field to access or modify the name input.
  ///
  /// This controller allows parent widgets to read the current name value
  /// or set it programmatically.
  final TextEditingController controller;

  /// Creates a FullnameInputField widget.
  ///
  /// The [controller] parameter is required and will be used to control the text
  /// input and access its value.
  const FullnameInputField({
    super.key,
    required this.controller,
  });

  @override
  State<FullnameInputField> createState() => _FullnameInputFieldState();
}

/// Validates the provided name value.
///
/// Returns an error message string if validation fails, or null if the name is valid.
///
/// The name must be:
/// - Not null or empty
/// - At least 3 characters long after trimming whitespace
/// - Contain only letters (A-Z, a-z) and spaces
String? _validateName(String? value) {
  final regex = RegExp(r'^[A-Za-z\s]+$');
  if (value == null || value.trim().isEmpty) {
    return 'Your name is required';
  } else if (value.trim().length < 3) {
    return 'Your name must be at least 3 characters';
  } else if (!regex.hasMatch(value.trim())) {
    return 'Sorry, only letters and spaces are allowed';
  }
  return null;
}

/// The state class for the FullnameInputField.
///
/// Manages the UI rendering of the input field with appropriate styling and validation.
class _FullnameInputFieldState extends State<FullnameInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: widget.controller,
        validator: _validateName,
        cursorColor: AppColors.primaryColor,
        decoration: const InputDecoration(
          labelText: 'Name',
          labelStyle: TextStyle(color: AppColors.textPrimary, fontSize: 16),
          prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
          filled: true,
          fillColor: AppColors.primaryBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(color: AppColors.accentRed),
        ),
      ),
    );
  }
}
