import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

class FullnameInputField extends StatefulWidget {
  final TextEditingController controller;

  const FullnameInputField({
    super.key,
    required this.controller,
  });

  @override
  State<FullnameInputField> createState() => _FullnameInputFieldState();
}

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
