import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase({required this.repository});

  Future<void> call(TaskEntity task) async {
    await repository.addTask(task);
  }
}
