import 'dart:async';
import 'package:flutter/material.dart';
import '../../di.dart';
import '../services/network_service.dart';

class ConnectivityBannerWidget extends StatefulWidget {
  const ConnectivityBannerWidget({super.key});

  @override
  State<ConnectivityBannerWidget> createState() => _ConnectivityBannerWidgetState();
}

class _ConnectivityBannerWidgetState extends State<ConnectivityBannerWidget> {
  NetworkService? _networkService;
  bool _wasOffline = false;
  bool _showRestoredBanner = false;
  Timer? _restoredTimer;

  @override
  void initState() {
    super.initState();
    if (getIt.isRegistered<NetworkService>()) {
      _networkService = getIt<NetworkService>();
      _networkService!.isConnectedNotifier.addListener(_onConnectionChanged);
      _wasOffline = !_networkService!.isConnected;
    }
  }

  @override
  void dispose() {
    _networkService?.isConnectedNotifier.removeListener(_onConnectionChanged);
    _restoredTimer?.cancel();
    super.dispose();
  }

  void _onConnectionChanged() {
    final isConnected = _networkService!.isConnected;
    _restoredTimer?.cancel();

    if (!isConnected) {
      setState(() {
        _wasOffline = true;
        _showRestoredBanner = false;
      });
    } else {
      if (_wasOffline) {
        setState(() {
          _showRestoredBanner = true;
          _wasOffline = false;
        });
        _restoredTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showRestoredBanner = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_networkService == null) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _networkService!.isConnectedNotifier,
      builder: (context, isConnected, child) {
        Widget bannerContent = const SizedBox.shrink();

        if (!isConnected) {
          bannerContent = Material(
            key: const ValueKey('offline_banner'),
            color: const Color(0xFFEF4444),
            elevation: 4,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No internet connection. Some features may not work.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (_showRestoredBanner) {
          bannerContent = Material(
            key: const ValueKey('restored_banner'),
            color: const Color(0xFF10B981),
            elevation: 4,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Internet connection restored.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: bannerContent,
        );
      },
    );
  }
}
