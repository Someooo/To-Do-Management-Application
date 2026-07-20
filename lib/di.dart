// Centralized dependency registration using GetIt.

import 'package:get_it/get_it.dart';
import 'package:my_template/core/services/api_service.dart';
import 'package:my_template/core/services/network_service.dart';
import 'package:my_template/core/services/storage_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<NetworkService>(() => NetworkService());
}
