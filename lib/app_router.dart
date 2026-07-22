import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/config/app_routes.dart';
import 'package:my_template/di.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_event.dart';
import 'features/authentication/presentation/bloc/auth_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
      child: const _SplashPageContent(),
    );
  }
}

class _SplashPageContent extends StatefulWidget {
  const _SplashPageContent();

  @override
  State<_SplashPageContent> createState() => _SplashPageContentState();
}

class _SplashPageContentState extends State<_SplashPageContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _navigationTimer;

  bool _isSplashTimerDone = false;
  String? _targetRoute;
  bool _hasNavigated = false;

  static const Color _greenAccent = Color(0xFF059669);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
    _startSplashTimer();
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startSplashTimer() {
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isSplashTimerDone = true;
        });
        _tryNavigate();
      }
    });
  }

  void _tryNavigate() {
    if (mounted && !_hasNavigated && _isSplashTimerDone && _targetRoute != null) {
      _hasNavigated = true;
      Navigator.of(context).pushReplacementNamed(_targetRoute!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              _targetRoute = AppRoutes.catalog;
            } else if (state is AuthUnauthenticated || state is AuthFailure) {
              _targetRoute = AppRoutes.login;
            }
            _tryNavigate();
          },
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/recovjo_logo.jpg',
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.business_rounded,
                              size: 48,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _greenAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'TECHNICAL ASSESSMENT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _greenAccent,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Recovery Software',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Prepared by Sami Almuhur',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 36),
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(_greenAccent),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

