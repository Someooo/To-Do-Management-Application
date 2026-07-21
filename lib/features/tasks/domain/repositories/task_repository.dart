import '../entities/task_entity.dart';

abstract class TaskRepository {
  /// Stream of all tasks.
  Stream<List<TaskEntity>> getTasks();

  /// Adds a new task.
  Future<void> addTask(TaskEntity task);

  /// Updates an existing task.
  Future<void> updateTask(TaskEntity task);

  /// Deletes a task by ID.
  Future<void> deleteTask(String id);
}
