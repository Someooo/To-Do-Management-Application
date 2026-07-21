import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';
import 'task_card_widget.dart';

class TaskListWidget extends StatelessWidget {
  final List<TaskEntity> tasks;
  final ValueChanged<TaskEntity>? onEditTask;
  final ValueChanged<TaskEntity>? onDeleteTask;

  const TaskListWidget({
    super.key,
    required this.tasks,
    this.onEditTask,
    this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCardWidget(
          task: task,
          onEdit: onEditTask != null ? () => onEditTask!(task) : null,
          onDelete: onDeleteTask != null ? () => onDeleteTask!(task) : null,
        );
      },
    );
  }
}
