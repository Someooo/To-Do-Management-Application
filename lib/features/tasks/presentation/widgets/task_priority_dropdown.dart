import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';

class TaskPriorityDropdown extends StatelessWidget {
  final TaskPriority value;
  final ValueChanged<TaskPriority?> onChanged;

  const TaskPriorityDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF404752);
    const inputBgColor = Color(0xFFF3F3F7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'Priority',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        DropdownButtonFormField<TaskPriority>(
          initialValue: value,
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down_rounded, color: labelColor),
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF1A1C1F),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBgColor,
            prefixIcon: const Icon(
              Icons.flag_outlined,
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
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: TaskPriority.low,
              child: Text('Low Priority'),
            ),
            DropdownMenuItem(
              value: TaskPriority.medium,
              child: Text('Medium Priority'),
            ),
            DropdownMenuItem(
              value: TaskPriority.high,
              child: Text('High Priority'),
            ),
          ],
        ),
      ],
    );
  }
}
