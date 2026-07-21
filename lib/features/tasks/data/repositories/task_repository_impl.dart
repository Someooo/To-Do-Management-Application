import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:my_template/core/errors/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<TaskEntity>> getTasks() {
    return remoteDataSource.getTasks().handleError((error) {
      throw _mapExceptionToFailure(error);
    });
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await remoteDataSource.addTask(taskModel);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await remoteDataSource.updateTask(taskModel);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is FirebaseException) {
      String msg = 'Server error. Please try again.';
      if (exception.code == 'permission-denied') {
        msg = 'You do not have permission to perform this action.';
      }
      return ServerFailure(message: msg, cause: exception);
    } else if (exception is SocketException) {
      return NetworkFailure(
        message: 'No internet connection. Please check your network.',
        cause: exception,
      );
    } else if (exception is TimeoutException) {
      return NetworkFailure(
        message: 'Connection timed out. Please try again.',
        cause: exception,
      );
    } else if (exception is Failure) {
      return exception;
    } else {
      return ServerFailure(
        message: exception.toString(),
        cause: exception,
      );
    }
  }
}
