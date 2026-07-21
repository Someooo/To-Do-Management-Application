import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';

class TaskStatusDropdown extends StatelessWidget {
  final TaskStatus value;
  final ValueChanged<TaskStatus?> onChanged;

  const TaskStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.grey.shade400 : const Color(0xFF404752);
    final inputBgColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'Status',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        DropdownButtonFormField<TaskStatus>(
          initialValue: value,
          onChanged: onChanged,
          isExpanded: true,
          dropdownColor: inputBgColor,
          icon: Icon(Icons.arrow_drop_down_rounded, color: labelColor),
          style: TextStyle(
            fontSize: 15,
            color: textColor,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBgColor,
            prefixIcon: Icon(
              Icons.task_alt_rounded,
              color: labelColor,
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: TaskStatus.todo,
              child: Text('To Do', overflow: TextOverflow.ellipsis),
            ),
            DropdownMenuItem(
              value: TaskStatus.inProgress,
              child: Text('In Progress', overflow: TextOverflow.ellipsis),
            ),
            DropdownMenuItem(
              value: TaskStatus.completed,
              child: Text('Completed', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ],
    );
  }
}
