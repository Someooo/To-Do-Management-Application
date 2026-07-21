import 'package:flutter/material.dart';

/// A widget that displays the welcome greeting with a waving hand emoji.
///
/// The hand performs three friendly waves (left → right → center) when the
/// widget first appears and then returns to the upright default position.
class WelcomeMessageWidget extends StatefulWidget {
  const WelcomeMessageWidget({super.key});

  @override
  State<WelcomeMessageWidget> createState() => _WelcomeMessageWidgetState();
}

class _WelcomeMessageWidgetState extends State<WelcomeMessageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;

  // Number of waves to perform.
  static const int _totalWaves = 3;
  int _wavesCompleted = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Duration for a single wave (0 → -10° → +10° → 0).
      duration: const Duration(milliseconds: 1200),
    );

    // Define a single wave as a TweenSequence.
    final wave = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -0.1745)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.1745, end: 0.1745)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.1745, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]);

    // The full animation repeats the wave sequence the required number of times.
    _rotationAnimation = wave.animate(_controller);

    // Listen for the end of each wave and trigger the next one if needed.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _wavesCompleted++;
        if (_wavesCompleted < _totalWaves) {
          // Restart the animation from the beginning for the next wave.
          _controller.forward(from: 0.0);
        }
        // When the final wave completes we simply stay at 0 rotation.
      }
    });

    // Start the first wave after the first frame.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controller.forward());
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
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
