import 'package:flutter/material.dart';

import '../app_router.dart';
import '../features/catalog/presentation/screens/catalog_screen.dart';

class AppRoutes {
  static const String initial = '/';

  static const String catalog = '/catalog';

  static const String login = '/auth/login';

  static Map<String, WidgetBuilder> get routes => {
        initial: (context) => const SplashPage(),
        catalog: (context) => const CatalogScreen(),
        login: (context) => const LoginPlaceholderPage(),
      };
}
