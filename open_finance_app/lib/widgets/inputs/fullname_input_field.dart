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

class _FullnameInputFieldState extends State<FullnameInputField> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: AppColors.primaryColor,
        decoration: const InputDecoration(
          labelText: 'Name',
          labelStyle:
              TextStyle(color: AppColors.textPrimary, fontSize: 16),
          prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
          filled: true,
          fillColor: AppColors.primaryBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(color: AppColors.accentRed),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your full name';
          }
          return null;
        },
      ),
    );
  }
}
