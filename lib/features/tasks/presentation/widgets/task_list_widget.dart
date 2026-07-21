import 'package:flutter/material.dart';
import 'package:my_template/features/tasks/presentation/widgets/animated_task_card.dart';
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        key: ValueKey<int>(tasks.length),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return AnimatedTaskCard(
            index: index,
            child: TaskCardWidget(
              task: task,
              onEdit: onEditTask != null ? () => onEditTask!(task) : null,
              onDelete: onDeleteTask != null ? () => onDeleteTask!(task) : null,
            ),
          );
        },
      ),
    );
  }
}
