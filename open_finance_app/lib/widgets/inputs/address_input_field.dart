import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A custom input field for collecting user address information.
///
/// This widget provides a styled text field specifically designed for address input
/// with appropriate validation, icon, and styling to match the application's design
/// language. It validates that the address is not empty and meets minimum length
/// requirements.
class AddressInputField extends StatefulWidget {
  /// Controller for the text field to access or modify the address input.
  ///
  /// This controller allows parent widgets to read the current address value
  /// or set it programmatically.
  final TextEditingController controller;

  /// Creates an AddressInputField widget.
  ///
  /// The [controller] parameter is required and will be used to control the text
  /// input and access its value.
  const AddressInputField({
    super.key,
    required this.controller,
  });

  @override
  State<AddressInputField> createState() => _AddressInputFieldState();
}

/// Validates the provided address value.
///
/// Returns an error message string if validation fails, or null if the address is valid.
///
/// The address must be:
/// - Not null or empty
/// - At least 5 characters long after trimming whitespace
String? _validateAddress(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Your address is required';
  } else if (value.trim().length < 5) {
    return 'Your address must be at least 5 characters';
  }
  return null;
}

/// The state class for the AddressInputField.
class _AddressInputFieldState extends State<AddressInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: widget.controller,
        validator: _validateAddress,
        cursorColor: AppColors.primaryColor,
        decoration: const InputDecoration(
          labelText: 'Address',
          labelStyle: TextStyle(color: AppColors.textPrimary, fontSize: 16),
          prefixIcon: Icon(Icons.house, color: AppColors.primaryColor),
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
