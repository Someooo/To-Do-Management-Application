import 'package:flutter/material.dart';

import '../app_router.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/authentication/presentation/pages/register_page.dart';

class AppRoutes {
  static const String initial = '/';

  static const String catalog = '/catalog';

  static const String login = '/auth/login';

  static const String register = '/auth/register';

  static Map<String, WidgetBuilder> get routes => {
        initial: (context) => const SplashPage(),
        catalog: (context) => const CatalogPlaceholderPage(),
        login: (context) => const LoginPage(),
        register: (context) => const RegisterPage(),
      };
}
