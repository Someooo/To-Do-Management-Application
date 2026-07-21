import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  StreamSubscription<List<TaskEntity>>? _tasksSubscription;

  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(const TaskInitial()) {
    on<TaskStarted>(_onTaskStarted);
    on<TaskSubscriptionRequested>(_onTaskSubscriptionRequested);
    on<TaskAdded>(_onTaskAdded);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskDeleted>(_onTaskDeleted);
    on<TasksUpdatedInternal>(_onTasksUpdatedInternal);
    on<TaskErrorInternal>(_onTaskErrorInternal);
  }

  void _onTaskStarted(
    TaskStarted event,
    Emitter<TaskState> emit,
  ) {
    add(const TaskSubscriptionRequested());
  }

  Future<void> _onTaskSubscriptionRequested(
    TaskSubscriptionRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    await _tasksSubscription?.cancel();
    _tasksSubscription = getTasksUseCase().listen(
      (tasks) => add(TasksUpdatedInternal(tasks)),
      onError: (error) => add(TaskErrorInternal(error.toString())),
    );
  }

  void _onTasksUpdatedInternal(
    TasksUpdatedInternal event,
    Emitter<TaskState> emit,
  ) {
    emit(TaskLoaded(tasks: event.tasks));
  }

  void _onTaskErrorInternal(
    TaskErrorInternal event,
    Emitter<TaskState> emit,
  ) {
    emit(TaskFailure(message: event.message));
  }

  Future<void> _onTaskAdded(
    TaskAdded event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await addTaskUseCase(event.task);
    } catch (e) {
      emit(TaskFailure(message: e.toString()));
    }
  }

  Future<void> _onTaskUpdated(
    TaskUpdated event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await updateTaskUseCase(event.task);
    } catch (e) {
      emit(TaskFailure(message: e.toString()));
    }
  }

  Future<void> _onTaskDeleted(
    TaskDeleted event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await deleteTaskUseCase(event.id);
    } catch (e) {
      emit(TaskFailure(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
