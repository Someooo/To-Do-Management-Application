import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final List<TaskEntity> allTasks;
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;

  const TaskLoaded({
    required this.tasks,
    required this.allTasks,
    this.statusFilter,
    this.priorityFilter,
  });

  @override
  List<Object?> get props => [tasks, allTasks, statusFilter, priorityFilter];
}

class TaskFailure extends TaskState {
  final String message;

  const TaskFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
