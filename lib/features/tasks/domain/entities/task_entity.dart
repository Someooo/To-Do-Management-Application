import 'package:equatable/equatable.dart';

enum TaskPriority {
  low,
  medium,
  high;

  static TaskPriority fromString(String? value) {
    return TaskPriority.values.firstWhere(
      (e) => e.name.toLowerCase() == value?.toLowerCase(),
      orElse: () => TaskPriority.medium,
    );
  }
}

enum TaskStatus {
  todo,
  inProgress,
  completed;

  static TaskStatus fromString(String? value) {
    return TaskStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value?.toLowerCase(),
      orElse: () => TaskStatus.todo,
    );
  }
}

enum TaskSortOption {
  none,
  dueDate,
  createdAt;

  String get label {
    switch (this) {
      case TaskSortOption.none:
        return 'No Sorting';
      case TaskSortOption.dueDate:
        return 'Due Date';
      case TaskSortOption.createdAt:
        return 'Created Date';
    }
  }
}

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        dueDate,
        createdAt,
        updatedAt,
      ];
}
