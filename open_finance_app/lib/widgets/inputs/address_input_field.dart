import 'package:flutter/material.dart';
import 'package:open_finance_app/theme/colors.dart';

class AddressInputField extends StatefulWidget {
  final TextEditingController controller;

  const AddressInputField({
    super.key,
    required this.controller,
  });

  @override
  State<AddressInputField> createState() => _AddressInputFieldState();
}

String? _validateAddress(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Your address is required';
  } else if (value.trim().length < 5) {
    return 'Your address must be at least 5 characters';
  }
  return null;
}

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
