import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/config/app_routes.dart';
import 'package:my_template/core/utils/app_snack_bar.dart';
import 'package:my_template/di.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/email_text_field.dart';
import '../widgets/login_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: const _ForgotPasswordPageContent(),
    );
  }
}

class _ForgotPasswordPageContent extends StatefulWidget {
  const _ForgotPasswordPageContent();

  @override
  State<_ForgotPasswordPageContent> createState() =>
      _ForgotPasswordPageContentState();
}

class _ForgotPasswordPageContentState
    extends State<_ForgotPasswordPageContent> {
  final _emailController = TextEditingController();

  final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetLinkPressed() {
    debugPrint('📱 [ForgotPasswordPage] Send Reset Link button pressed');
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      debugPrint('⚠️ [ForgotPasswordPage] Validation failed: Email is empty');
      AppSnackBar.showError(context, 'Please enter your email address');
      return;
    }

    if (!_emailRegex.hasMatch(email)) {
      debugPrint('⚠️ [ForgotPasswordPage] Validation failed: Invalid email format');
      AppSnackBar.showError(context, 'Please enter a valid email address');
      return;
    }

    debugPrint('📱 [ForgotPasswordPage] Validation passed for email: $email');
    context.read<AuthBloc>().add(
          AuthForgotPasswordRequested(email: email),
        );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF9F9FD);
    const primaryColor = Color(0xFF0060A9);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1F)),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            }
          },
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              debugPrint('📱 [ForgotPasswordPage] State received: AuthLoading');
            } else if (state is AuthPasswordResetEmailSent) {
              debugPrint(
                  '📱 [ForgotPasswordPage] State received: AuthPasswordResetEmailSent');
              AppSnackBar.showSuccess(
                context,
                "Password reset email has been sent successfully. If you don't see it in your inbox, please check your Spam/Junk folder.",
              );
            } else if (state is AuthFailure) {
              debugPrint(
                  '📱 [ForgotPasswordPage] State received: AuthFailure (Message: ${state.message})');
              AppSnackBar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.lock_reset_rounded,
                    size: 64,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C1F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter your email address below and we will send you a link to reset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  EmailTextField(
                    controller: _emailController,
                  ),
                  const SizedBox(height: 24),
                  LoginButton(
                    label: 'Send Reset Link',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _onSendResetLinkPressed,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed(AppRoutes.login);
                        }
                      },
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
