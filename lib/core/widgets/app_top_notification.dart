import 'dart:async';
import 'package:flutter/material.dart';

enum NotificationType { success, error, info }

class AppTopNotification {
  static OverlayEntry? _currentOverlay;
  static Timer? _dismissTimer;

  static void show(
    BuildContext context, {
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _dismissTimer?.cancel();
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlayState = Overlay.of(context, rootOverlay: true);

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _TopNotificationWidget(
        message: message,
        type: type,
        onDismiss: () {
          _dismissTimer?.cancel();
          if (_currentOverlay == overlayEntry) {
            overlayEntry.remove();
            _currentOverlay = null;
          }
        },
      ),
    );

    _currentOverlay = overlayEntry;
    overlayState.insert(overlayEntry);

    _dismissTimer = Timer(duration, () {
      if (_currentOverlay == overlayEntry) {
        overlayEntry.remove();
        _currentOverlay = null;
      }
    });
  }
}

class _TopNotificationWidget extends StatefulWidget {
  final String message;
  final NotificationType type;
  final VoidCallback onDismiss;

  const _TopNotificationWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_TopNotificationWidget> createState() => _TopNotificationWidgetState();
}

class _TopNotificationWidgetState extends State<_TopNotificationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + 8;

    final Color bgColor;
    final IconData icon;

    switch (widget.type) {
      case NotificationType.success:
        bgColor = const Color(0xFF059669);
        icon = Icons.check_circle_rounded;
        break;
      case NotificationType.error:
        bgColor = const Color(0xFFDC2626);
        icon = Icons.error_outline_rounded;
        break;
      case NotificationType.info:
        bgColor = const Color(0xFF2563EB);
        icon = Icons.info_outline_rounded;
        break;
    }

    return Positioned(
      top: topPadding,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _handleDismiss,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
