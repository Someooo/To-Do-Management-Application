import 'package:flutter/material.dart';

import '../app_router.dart';
import '../features/authentication/presentation/pages/forgot_password_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/authentication/presentation/pages/register_page.dart';
import '../features/tasks/presentation/pages/add_task_page.dart';
import '../features/tasks/presentation/pages/home_page.dart';

class AppRoutes {
  static const String initial = '/';

  static const String catalog = '/catalog';

  static const String addTask = '/tasks/add';

  static const String login = '/auth/login';

  static const String register = '/auth/register';

  static const String forgotPassword = '/auth/forgot-password';

  static Map<String, WidgetBuilder> get routes => {
        initial: (context) => const SplashPage(),
        catalog: (context) => const HomePage(),
        addTask: (context) => const AddTaskPage(),
        login: (context) => const LoginPage(),
        register: (context) => const RegisterPage(),
        forgotPassword: (context) => const ForgotPasswordPage(),
      };
}
