// Centralized dependency registration using GetIt.

import 'package:get_it/get_it.dart';
import 'package:my_template/core/services/api_service.dart';
import 'package:my_template/core/services/network_service.dart';
import 'package:my_template/core/services/storage_service.dart';
import 'package:my_template/features/catalog/data/datasources/catalog_local_data_source.dart';
import 'package:my_template/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:my_template/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:my_template/features/catalog/presentation/bloc/catalog_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<NetworkService>(() => NetworkService());

  // Catalog feature
  getIt.registerLazySingleton<CatalogLocalDataSource>(
    () => CatalogLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(dataSource: getIt<CatalogLocalDataSource>()),
  );
  getIt.registerFactory<CatalogBloc>(
    () => CatalogBloc(repository: getIt<CatalogRepository>()),
  );
}
