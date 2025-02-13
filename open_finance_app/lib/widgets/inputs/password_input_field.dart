import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInputField({
    super.key,
    required this.controller, required String? Function(dynamic value) validator,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: AppColors.primaryColor,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle:
              const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          prefixIcon: const Icon(Icons.lock, color: AppColors.primaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          filled: true,
          fillColor: AppColors.primaryBackground,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          errorStyle: const TextStyle(color: AppColors.accentRed),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }
}
