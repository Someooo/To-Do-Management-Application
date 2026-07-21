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
  final String searchQuery;
  final TaskSortOption sortOption;
  final String? message;

  const TaskLoaded({
    required this.tasks,
    required this.allTasks,
    this.statusFilter,
    this.priorityFilter,
    this.searchQuery = '',
    this.sortOption = TaskSortOption.none,
    this.message,
  });

  TaskLoaded copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? allTasks,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    String? searchQuery,
    TaskSortOption? sortOption,
    String? message,
    bool clearMessage = false,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      allTasks: allTasks ?? this.allTasks,
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
        tasks,
        allTasks,
        statusFilter,
        priorityFilter,
        searchQuery,
        sortOption,
        message,
      ];
}

class TaskFailure extends TaskState {
  final String message;

  const TaskFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
