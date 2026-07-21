import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase({required this.repository});

  Future<void> call(TaskEntity task) async {
    await repository.updateTask(task);
  }
}
