import 'package:flutter/material.dart';
import '../widgets/app_top_notification.dart';

class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    AppTopNotification.show(
      context,
      message: message,
      type: NotificationType.success,
    );
  }

  static void showError(BuildContext context, String message) {
    AppTopNotification.show(
      context,
      message: message,
      type: NotificationType.error,
    );
  }

  static void showInfo(BuildContext context, String message) {
    AppTopNotification.show(
      context,
      message: message,
      type: NotificationType.info,
    );
  }
}
