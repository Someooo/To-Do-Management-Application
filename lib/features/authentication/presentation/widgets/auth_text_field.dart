import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.autovalidateMode,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF404752);
    const inputBgColor = Color(0xFFF3F3F7);
    const textColor = Color(0xFF1A1C1F);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          style: const TextStyle(
            fontSize: 15,
            color: textColor,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBgColor,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
            ),
            prefixIcon: Icon(
              widget.icon,
              color: labelColor,
              size: 20,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: labelColor,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
