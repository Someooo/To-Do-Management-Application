import 'package:flutter/material.dart';
import '../../di.dart';
import '../services/network_service.dart';

class ConnectivityBannerWidget extends StatelessWidget {
  const ConnectivityBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<NetworkService>()) {
      return const SizedBox.shrink();
    }

    final networkService = getIt<NetworkService>();

    return ValueListenableBuilder<bool>(
      valueListenable: networkService.isConnectedNotifier,
      builder: (context, isConnected, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isConnected
              ? const SizedBox.shrink()
              : Material(
                  key: const ValueKey('offline_banner'),
                  color: Colors.red.shade700,
                  elevation: 4,
                  child: SafeArea(
                    bottom: false,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
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
                              'Please check your internet connection.',
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
                ),
        );
      },
    );
  }
}
