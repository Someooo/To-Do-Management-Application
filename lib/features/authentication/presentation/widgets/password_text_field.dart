import 'package:flutter/material.dart';
import 'auth_text_field.dart';

class PasswordTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const PasswordTextField({
    super.key,
    this.label = 'Password',
    this.hintText = '••••••••',
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      label: label,
      hintText: hintText,
      icon: Icons.lock_outline_rounded,
      isPassword: true,
      controller: controller,
      onChanged: onChanged,
    );
  }
}
