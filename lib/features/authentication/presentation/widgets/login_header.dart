import 'package:flutter/material.dart';
import 'auth_header_widget.dart';

class LoginHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const LoginHeader({
    super.key,
    this.title = 'Welcome back',
    this.subtitle = 'Log in to stay on top of your flow.',
  });

  @override
  Widget build(BuildContext context) {
    return AuthHeaderWidget(
      title: title,
      subtitle: subtitle,
    );
  }
}
