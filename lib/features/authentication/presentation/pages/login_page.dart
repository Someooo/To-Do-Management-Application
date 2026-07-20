import 'package:flutter/material.dart';

import '../widgets/email_text_field.dart';
import '../widgets/login_button.dart';
import '../widgets/login_header.dart';
import '../widgets/password_text_field.dart';
import '../widgets/signup_prompt_widget.dart';
import '../widgets/social_auth_buttons_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF9F9FD);
    const primaryColor = Color(0xFF0060A9);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {},
              //     style: TextButton.styleFrom(
              //       padding: EdgeInsets.zero,
              //       minimumSize: Size.zero,
              //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //     ),
              //     child: const Text(
              //       'Forgot password?',
              //       style: TextStyle(
              //         fontSize: 13,
              //         fontWeight: FontWeight.w600,
              //         color: primaryColor,
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 24),
              LoginButton(
                onPressed: () {},
              ),
              const SizedBox(height: 32),
              // SocialAuthButtonsWidget(
              //   onGooglePressed: () {},
              //   onApplePressed: () {},
              // ),
              // const SizedBox(height: 32),
              // SignupPromptWidget(
              //   onSignupPressed: () {},
              // ),
              // const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
