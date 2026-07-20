import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../utils/toast_utils.dart';

class NetworkService {
  NetworkService() {
    _initConnectivity();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final ValueNotifier<bool> isConnectedNotifier = ValueNotifier<bool>(true);

  bool get isConnected => isConnectedNotifier.value;

  void dispose() {
    _subscription?.cancel();
    isConnectedNotifier.dispose();
  }

  Future<void> _initConnectivity() async {
    await checkConnection();

    try {
      _subscription = _connectivity.onConnectivityChanged.listen(
        _handleConnectivityChange,
        onError: (e) {
          if (kDebugMode) debugPrint('Connectivity stream error: $e');
        },
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Connectivity subscription error: $e');
    }
  }

  Future<void> _handleConnectivityChange(
      List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none)) {
      _updateStatus(false);
      return;
    }

    final hasInternet = await _hasRealInternetAccess();
    _updateStatus(hasInternet);
  }

  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.contains(ConnectivityResult.none)) {
        _updateStatus(false);
        return false;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Connectivity check error: $e');
    }

    final hasInternet = await _hasRealInternetAccess();
    _updateStatus(hasInternet);
    return hasInternet;
  }

  Future<bool> _hasRealInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Internet lookup error: $e');
      }
      return false;
    }
  }

  void _updateStatus(bool newStatus) {
    if (isConnectedNotifier.value == newStatus) return;

    isConnectedNotifier.value = newStatus;

    if (!newStatus) {
      ToastUtils.showNoInternetSnackbar();
    } else {
      ToastUtils.showInternetRestoredSnackbar();
    }
  }
}
