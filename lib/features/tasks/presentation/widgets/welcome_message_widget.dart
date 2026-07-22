import 'package:flutter/material.dart';

class WelcomeMessageWidget extends StatefulWidget {
  const WelcomeMessageWidget({super.key});

  @override
  State<WelcomeMessageWidget> createState() => _WelcomeMessageWidgetState();
}

class _WelcomeMessageWidgetState extends State<WelcomeMessageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;

  static const int _maxRepeats = 3;
  int _currentRepeats = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _rotationAnimation = Tween<double>(
      begin: -0.1745,
      end: 0.1745,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _currentRepeats++;
        if (_currentRepeats < _maxRepeats) {
          _controller.forward();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Welcome Back ',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        RotationTransition(
          turns: _rotationAnimation,
          child: const Text(
            '👋',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
