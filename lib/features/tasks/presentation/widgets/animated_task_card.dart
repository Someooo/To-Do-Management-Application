import 'package:flutter/material.dart';

/// Wraps a task card with a subtle fade‑in and slide‑up animation.
/// The animation runs once when the widget is first built.
class AnimatedTaskCard extends StatelessWidget {
  final Widget child;
  final int index;

  const AnimatedTaskCard({Key? key, required this.child, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Stagger each item slightly using the index.
    final startDelay = Duration(milliseconds: 50 * index);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        final offsetY = (1 - value) * 20;
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, offsetY),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
