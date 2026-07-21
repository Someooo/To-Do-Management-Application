import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:my_template/core/services/api_service.dart';
import 'package:my_template/core/services/network_service.dart';
import 'package:my_template/core/services/storage_service.dart';
import 'package:my_template/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:my_template/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_template/features/authentication/domain/repositories/auth_repository.dart';
import 'package:my_template/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:my_template/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:my_template/features/authentication/domain/usecases/login_usecase.dart';
import 'package:my_template/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:my_template/features/authentication/domain/usecases/register_usecase.dart';
import 'package:my_template/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:my_template/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:my_template/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:my_template/features/tasks/domain/repositories/task_repository.dart';
import 'package:my_template/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:my_template/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:my_template/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:my_template/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:my_template/features/tasks/presentation/bloc/task_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<NetworkService>(() => NetworkService());

  // Authentication Feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: getIt()));

  getIt.registerLazySingleton(() => LoginUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(repository: getIt()));

  getIt.registerFactory(() => AuthBloc(
        loginUseCase: getIt(),
        registerUseCase: getIt(),
        logoutUseCase: getIt(),
        getCurrentUserUseCase: getIt(),
        forgotPasswordUseCase: getIt(),
      ));

  // Task Feature
  getIt.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(firestore: FirebaseFirestore.instance));
  getIt.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(remoteDataSource: getIt()));

  getIt.registerLazySingleton(() => GetTasksUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => AddTaskUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateTaskUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteTaskUseCase(repository: getIt()));

  getIt.registerFactory(() => TaskBloc(
        getTasksUseCase: getIt(),
        addTaskUseCase: getIt(),
        updateTaskUseCase: getIt(),
        deleteTaskUseCase: getIt(),
      ));
}
