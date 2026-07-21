import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase({required this.repository});

  Stream<List<TaskEntity>> call() {
    return repository.getTasks();
  }
}
