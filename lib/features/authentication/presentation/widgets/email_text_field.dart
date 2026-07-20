import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const EmailTextField({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF404752);
    const inputBgColor = Color(0xFFF3F3F7);
    const textColor = Color(0xFF1A1C1F);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'Email Address',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: inputBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 15,
              color: textColor,
            ),
            decoration: InputDecoration(
              hintText: 'name@company.com',
              hintStyle: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade400,
              ),
              prefixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: labelColor,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
