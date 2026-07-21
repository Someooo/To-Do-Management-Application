import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';
import 'task_card_widget.dart';

class TaskListWidget extends StatelessWidget {
  final List<TaskEntity> tasks;

  const TaskListWidget({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCardWidget(task: task);
      },
    );
  }
}
