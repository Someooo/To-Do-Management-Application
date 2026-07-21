import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/tasks/presentation/widgets/welcome_message_widget.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../authentication/presentation/widgets/logout_confirmation_dialog.dart';
import '../../../../core/bloc/theme_bloc.dart';
import '../../../../core/bloc/theme_event.dart';
import '../../../../core/bloc/theme_state.dart';
import 'animated_avatar.dart';

class HomeHeaderWidget extends StatefulWidget {
  final int taskCount;

  const HomeHeaderWidget({
    super.key,
    required this.taskCount,
  });

  @override
  State<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _opacityAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    // Start entrance animation after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getInitials(String email) {
    if (email.isEmpty) return 'U';
    final parts = email.split('@');
    final name = parts.first;
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String email = '';
        if (state is AuthAuthenticated) {
          email = state.user.email;
        }
        final initials = _getInitials(email);
        return FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedAvatar(initials: initials),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TaskFlow',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: -0.3,
                            ),
                          ),
                          if (email.isNotEmpty)
                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.logout_rounded,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                        size: 22,
                      ),
                      tooltip: 'Logout',
                      style: IconButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade800
                                : const Color(0xFFF3F4F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final confirmed =
                            await LogoutConfirmationDialog.show(context);
                        if (confirmed == true && context.mounted) {
                          context
                              .read<AuthBloc>()
                              .add(const AuthLogoutRequested());
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, themeState) {
                        final isDark = themeState.themeMode == ThemeMode.dark;
                        return IconButton(
                          icon: Icon(
                            isDark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            color: isDark
                                ? const Color(0xFFFBBF24)
                                : const Color(0xFF4B5563),
                            size: 22,
                          ),
                          tooltip: isDark
                              ? 'Switch to Light Mode'
                              : 'Switch to Dark Mode',
                          style: IconButton.styleFrom(
                            backgroundColor: isDark
                                ? Colors.grey.shade800
                                : const Color(0xFFF3F4F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<ThemeBloc>().add(ThemeThemeChanged(
                                isDark ? ThemeMode.light : ThemeMode.dark));
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const WelcomeMessageWidget(),
                const SizedBox(height: 4),
                Text(
                  widget.taskCount > 0
                      ? 'You have ${widget.taskCount} ${widget.taskCount == 1 ? 'task' : 'tasks'} today.'
                      : "Let's manage your tasks today.",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
