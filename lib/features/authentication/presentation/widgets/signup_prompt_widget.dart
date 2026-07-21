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
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: onSignupPressed,
          child: Text(
            actionText,
            style: TextStyle(
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
