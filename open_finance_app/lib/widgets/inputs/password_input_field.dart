import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

/// A reusable password input field with show/hide functionality.
///
/// This widget provides a consistent password input experience across the app with:
/// - Password visibility toggle
/// - Consistent styling with app theme
/// - Built-in validation support
/// - Customizable hint text
class PasswordInputField extends StatefulWidget {
  /// Controller for accessing and manipulating the input field's text.
  final TextEditingController controller;
  
  /// Optional validator function to check password validity.
  ///
  /// Returns error message string or null if validation passes.
  final String? Function(String?)? validator;
  
  /// Optional hint text displayed when field is empty.
  final String? hintText;

  /// Creates a PasswordInputField widget.
  ///
  /// The [controller] parameter is required to manage the text input.
  /// [validator] is optional but recommended for form validation.
  /// [hintText] allows customizing the placeholder text.
  const PasswordInputField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

/// State management class for PasswordInputField.
///
/// Handles the toggle between visible and obscured password text.
class _PasswordInputFieldState extends State<PasswordInputField> {
  /// Controls whether the password text is hidden (true) or visible (false).
  ///
  /// Defaults to true for security.
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        // Use the provided controller to manage input text
        controller: widget.controller,
        // Set cursor color to match app theme
        cursorColor: AppColors.primaryColor,
        // Apply the current visibility state to determine if text is hidden
        obscureText: _obscureText,
        decoration: InputDecoration(
          // Default label if no hint text is provided
          labelText: 'Password',
          labelStyle:
              const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          // Lock icon for visual indication of password field
          prefixIcon: const Icon(Icons.lock, color: AppColors.primaryColor),
          // Toggle button for password visibility
          suffixIcon: IconButton(
            icon: Icon(
              // Change icon based on current visibility state
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.primaryColor,
            ),
            // Toggle password visibility when pressed
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          // Apply consistent styling with app theme
          filled: true,
          fillColor: AppColors.primaryBackground,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          // Error message styling
          errorStyle: const TextStyle(color: AppColors.accentRed),
          // Use provided hint text or default to null
          hintText: widget.hintText,
        ),
        // Use provided validator or fall back to basic empty check
        validator: widget.validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }
}
