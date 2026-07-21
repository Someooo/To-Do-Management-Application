import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCardWidget({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildPriorityBadge(context, task.priority),
                if (onEdit != null) ...[
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: onEdit,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0060A9),
                      ),
                    ),
                  ),
                ],
                if (onDelete != null) ...[
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: isDark ? Colors.red.shade400 : Colors.red.shade600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge(context, task.status),
                if (task.dueDate != null)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(task.dueDate!),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context, TaskPriority priority) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color bg;
    Color fg;
    String label;

    switch (priority) {
      case TaskPriority.high:
        bg = isDark ? Colors.red.withValues(alpha: 0.15) : Colors.red.shade50;
        fg = isDark ? Colors.red.shade300 : Colors.red.shade700;
        label = 'High';
        break;
      case TaskPriority.medium:
        bg = isDark ? Colors.orange.withValues(alpha: 0.15) : Colors.orange.shade50;
        fg = isDark ? Colors.orange.shade300 : Colors.orange.shade800;
        label = 'Medium';
        break;
      case TaskPriority.low:
        bg = isDark ? Colors.green.withValues(alpha: 0.15) : Colors.green.shade50;
        fg = isDark ? Colors.green.shade300 : Colors.green.shade700;
        label = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, TaskStatus status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case TaskStatus.todo:
        bg = isDark ? const Color(0xFF0060A9).withValues(alpha: 0.2) : const Color(0xFFE8F1FF);
        fg = isDark ? const Color(0xFF60A5FA) : const Color(0xFF0060A9);
        label = 'To Do';
        break;
      case TaskStatus.inProgress:
        bg = isDark ? Colors.purple.withValues(alpha: 0.15) : Colors.purple.shade50;
        fg = isDark ? Colors.purple.shade300 : Colors.purple.shade700;
        label = 'In Progress';
        break;
      case TaskStatus.completed:
        bg = isDark ? Colors.teal.withValues(alpha: 0.15) : Colors.teal.shade50;
        fg = isDark ? Colors.teal.shade300 : Colors.teal.shade700;
        label = 'Completed';
        break;
    }

    return PopupMenuButton<TaskStatus>(
      tooltip: 'Change Status',
      onSelected: (TaskStatus newStatus) {
        if (newStatus != status) {
          final updatedTask = TaskEntity(
            id: task.id,
            title: task.title,
            description: task.description,
            priority: task.priority,
            status: newStatus,
            dueDate: task.dueDate,
            createdAt: task.createdAt,
            updatedAt: task.updatedAt,
          );
          context.read<TaskBloc>().add(TaskUpdated(updatedTask));
        }
      },
      itemBuilder: (context) => TaskStatus.values.map((s) {
        String text;
        switch (s) {
          case TaskStatus.todo:
            text = 'To Do';
            break;
          case TaskStatus.inProgress:
            text = 'In Progress';
            break;
          case TaskStatus.completed:
            text = 'Completed';
            break;
        }
        return PopupMenuItem<TaskStatus>(
          value: s,
          child: Text(text),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }
}
