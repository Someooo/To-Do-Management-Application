import 'package:flutter/material.dart';

class SocialAuthButtonsWidget extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  const SocialAuthButtonsWidget({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    const dividerColor = Color(0xFFE2E2E6);
    const labelColor = Color(0xFF717783);

    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider(color: dividerColor, thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Expanded(child: Divider(color: dividerColor, thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialCircleButton(
              onPressed: onGooglePressed,
              child: const Text(
                'G',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEA4335),
                ),
              ),
            ),
            const SizedBox(width: 20),
            _SocialCircleButton(
              onPressed: onApplePressed,
              child: const Icon(
                Icons.apple_rounded,
                size: 26,
                color: Color(0xFF1A1C1F),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const _SocialCircleButton({
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFE2E2E6),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}
