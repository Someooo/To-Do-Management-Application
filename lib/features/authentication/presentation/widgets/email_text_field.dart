import 'package:flutter/material.dart';
import 'auth_text_field.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const EmailTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      label: 'Email Address',
      hintText: 'name@company.com',
      icon: Icons.mail_outline_rounded,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: autovalidateMode,
    );
  }
}
