import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';

class TaskSortWidget extends StatelessWidget {
  final TaskSortOption selectedSortOption;
  final ValueChanged<TaskSortOption> onSortOptionChanged;

  const TaskSortWidget({
    super.key,
    required this.selectedSortOption,
    required this.onSortOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF1F2937);
    const primaryColor = Color(0xFF3B82F6);

    return PopupMenuButton<TaskSortOption>(
      initialValue: selectedSortOption,
      onSelected: onSortOptionChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      color: Colors.white,
      itemBuilder: (context) => TaskSortOption.values.map((option) {
        final isSelected = option == selectedSortOption;
        return PopupMenuItem<TaskSortOption>(
          value: option,
          child: Row(
            children: [
              Icon(
                _getIconForOption(option),
                color: isSelected ? primaryColor : const Color(0xFF6B7280),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                option.label,
                style: TextStyle(
                  color: isSelected ? primaryColor : textDark,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                const Icon(
                  Icons.check_rounded,
                  color: primaryColor,
                  size: 18,
                ),
              ],
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sort_rounded,
              color: Color(0xFF4B5563),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Sort: ${selectedSortOption.label}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: Color(0xFF4B5563),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForOption(TaskSortOption option) {
    switch (option) {
      case TaskSortOption.none:
        return Icons.sort_rounded;
      case TaskSortOption.dueDate:
        return Icons.calendar_today_rounded;
      case TaskSortOption.createdAt:
        return Icons.access_time_rounded;
    }
  }
}
