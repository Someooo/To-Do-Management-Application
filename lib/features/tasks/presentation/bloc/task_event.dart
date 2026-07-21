import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TaskStarted extends TaskEvent {
  const TaskStarted();
}

class TaskSubscriptionRequested extends TaskEvent {
  const TaskSubscriptionRequested();
}

class TaskAdded extends TaskEvent {
  final TaskEntity task;

  const TaskAdded(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskUpdated extends TaskEvent {
  final TaskEntity task;

  const TaskUpdated(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDeleted extends TaskEvent {
  final String id;

  const TaskDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class TasksUpdatedInternal extends TaskEvent {
  final List<TaskEntity> tasks;

  const TasksUpdatedInternal(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskErrorInternal extends TaskEvent {
  final String message;

  const TaskErrorInternal(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskFilterChanged extends TaskEvent {
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;

  const TaskFilterChanged({
    this.statusFilter,
    this.priorityFilter,
  });

  @override
  List<Object?> get props => [statusFilter, priorityFilter];
}

