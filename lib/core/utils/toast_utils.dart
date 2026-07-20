import 'package:flutter/material.dart';

class ToastUtils {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showError(String error, [BuildContext? context]) {
    final messenger = context != null
        ? ScaffoldMessenger.of(context)
        : messengerKey.currentState;

    messenger?.showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccess(String message, [BuildContext? context]) {
    final messenger = context != null
        ? ScaffoldMessenger.of(context)
        : messengerKey.currentState;

    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showErrorSnackbar(String title, String message) {
    showError('$title: $message');
  }

  static void showSuccessSnackbar(String title, String message) {
    showSuccess('$title: $message');
  }

  static void showWarningSnackbar(String title, String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showNoInternetSnackbar() {
    messengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('Please check your internet connection.')),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(12),
        duration: Duration(seconds: 4),
      ),
    );
  }

  static void showInternetRestoredSnackbar() {
    messengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.wifi_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('Internet connection restored.')),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(12),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static void dismissSnackbar() {
    messengerKey.currentState?.hideCurrentSnackBar();
  }
}
