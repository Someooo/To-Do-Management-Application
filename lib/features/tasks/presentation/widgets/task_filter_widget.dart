import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';

class TaskFilterWidget extends StatelessWidget {
  final TaskStatus? selectedStatus;
  final TaskPriority? selectedPriority;
  final ValueChanged<TaskStatus?> onStatusChanged;
  final ValueChanged<TaskPriority?> onPriorityChanged;

  const TaskFilterWidget({
    super.key,
    required this.selectedStatus,
    required this.selectedPriority,
    required this.onStatusChanged,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3B82F6);
    const unselectedBg = Color(0xFFF3F4F6);
    const textDark = Color(0xFF1F2937);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Filter Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildStatusCapsule(
                label: 'All',
                isSelected: selectedStatus == null,
                onTap: () => onStatusChanged(null),
                primaryColor: primaryColor,
                unselectedBg: unselectedBg,
                textDark: textDark,
              ),
              const SizedBox(width: 8),
              _buildStatusCapsule(
                label: 'Pending',
                isSelected: selectedStatus == TaskStatus.todo,
                onTap: () => onStatusChanged(
                  selectedStatus == TaskStatus.todo ? null : TaskStatus.todo,
                ),
                primaryColor: primaryColor,
                unselectedBg: unselectedBg,
                textDark: textDark,
              ),
              const SizedBox(width: 8),
              _buildStatusCapsule(
                label: 'In Progress',
                isSelected: selectedStatus == TaskStatus.inProgress,
                onTap: () => onStatusChanged(
                  selectedStatus == TaskStatus.inProgress
                      ? null
                      : TaskStatus.inProgress,
                ),
                primaryColor: primaryColor,
                unselectedBg: unselectedBg,
                textDark: textDark,
              ),
              const SizedBox(width: 8),
              _buildStatusCapsule(
                label: 'Completed',
                isSelected: selectedStatus == TaskStatus.completed,
                onTap: () => onStatusChanged(
                  selectedStatus == TaskStatus.completed
                      ? null
                      : TaskStatus.completed,
                ),
                primaryColor: primaryColor,
                unselectedBg: unselectedBg,
                textDark: textDark,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Priority Filter Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              const Text(
                'Priority:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(width: 10),
              _buildPriorityCapsule(
                label: 'All',
                isSelected: selectedPriority == null,
                onTap: () => onPriorityChanged(null),
                primaryColor: primaryColor,
              ),
              const SizedBox(width: 8),
              _buildPriorityCapsule(
                label: 'Low',
                isSelected: selectedPriority == TaskPriority.low,
                onTap: () => onPriorityChanged(
                  selectedPriority == TaskPriority.low ? null : TaskPriority.low,
                ),
                primaryColor: primaryColor,
              ),
              const SizedBox(width: 8),
              _buildPriorityCapsule(
                label: 'Medium',
                isSelected: selectedPriority == TaskPriority.medium,
                onTap: () => onPriorityChanged(
                  selectedPriority == TaskPriority.medium
                      ? null
                      : TaskPriority.medium,
                ),
                primaryColor: primaryColor,
              ),
              const SizedBox(width: 8),
              _buildPriorityCapsule(
                label: 'High',
                isSelected: selectedPriority == TaskPriority.high,
                onTap: () => onPriorityChanged(
                  selectedPriority == TaskPriority.high
                      ? null
                      : TaskPriority.high,
                ),
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCapsule({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
    required Color unselectedBg,
    required Color textDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : unselectedBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textDark,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityCapsule({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFD1D5DB),
            width: isSelected ? 1.8 : 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : const Color(0xFF374151),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
