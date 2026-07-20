import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/config/app_routes.dart';
import 'package:my_template/di.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/email_text_field.dart';
import '../widgets/login_button.dart';
import '../widgets/login_header.dart';
import '../widgets/password_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: const _LoginPageContent(),
    );
  }
}

class _LoginPageContent extends StatefulWidget {
  const _LoginPageContent();

  @override
  State<_LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<_LoginPageContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    debugPrint('📱 [LoginPage] Login button pressed');
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      debugPrint('⚠️ [LoginPage] Validation failed: Email is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    if (password.isEmpty) {
      debugPrint('⚠️ [LoginPage] Validation failed: Password is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password')),
      );
      return;
    }

    debugPrint('📱 [LoginPage] Validation passed for email: $email');
    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: email,
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF9F9FD);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              debugPrint('📱 [LoginPage] State received: AuthLoading');
            } else if (state is AuthAuthenticated) {
              debugPrint(
                  '📱 [LoginPage] State received: AuthAuthenticated (User ID: ${state.user.id})');
              debugPrint('📱 [LoginPage] Navigating to catalog screen...');
              Navigator.of(context).pushReplacementNamed(AppRoutes.catalog);
            } else if (state is AuthFailure) {
              debugPrint(
                  '📱 [LoginPage] State received: AuthFailure (Message: ${state.message})');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(),
                  const SizedBox(height: 32),
                  EmailTextField(
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  PasswordTextField(
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  LoginButton(
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _onLoginPressed,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
