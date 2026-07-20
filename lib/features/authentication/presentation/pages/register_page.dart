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
import '../widgets/login_header.dart';
import '../widgets/password_text_field.dart';
import '../widgets/signup_prompt_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: const _RegisterPageContent(),
    );
  }
}

class _RegisterPageContent extends StatefulWidget {
  const _RegisterPageContent();

  @override
  State<_RegisterPageContent> createState() => _RegisterPageContentState();
}

class _RegisterPageContentState extends State<_RegisterPageContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty) {
      AppSnackBar.showError(context, 'Please enter your email address');
      return;
    }

    if (password.isEmpty) {
      AppSnackBar.showError(context, 'Please enter your password');
      return;
    }

    if (confirmPassword.isEmpty) {
      AppSnackBar.showError(context, 'Please confirm your password');
      return;
    }

    if (password != confirmPassword) {
      AppSnackBar.showError(context, 'Passwords do not match');
      return;
    }

    context.read<AuthBloc>().add(
          AuthRegisterRequested(
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
            if (state is AuthAuthenticated) {
              AppSnackBar.showSuccess(context, 'Account created successfully.');
              Navigator.of(context).pushReplacementNamed(AppRoutes.catalog);
            } else if (state is AuthFailure) {
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
                  const LoginHeader(
                    title: 'Create Account',
                    subtitle: 'Sign up to get started',
                  ),
                  const SizedBox(height: 32),
                  EmailTextField(
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  PasswordTextField(
                    label: 'Password',
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 16),
                  PasswordTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 24),
                  LoginButton(
                    label: 'Register',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _onRegisterPressed,
                  ),
                  const SizedBox(height: 32),
                  SignupPromptWidget(
                    promptText: 'Already have an account? ',
                    actionText: 'Log in',
                    onSignupPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.login);
                    },
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
