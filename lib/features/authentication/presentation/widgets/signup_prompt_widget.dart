import 'package:flutter/material.dart';

class SignupPromptWidget extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback? onSignupPressed;

  const SignupPromptWidget({
    super.key,
    this.promptText = "Don't have an account? ",
    this.actionText = 'Sign up',
    this.onSignupPressed,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0060A9);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF404752),
          ),
        ),
        GestureDetector(
          onTap: onSignupPressed,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
