import '../entities/task_entity.dart';

class FilterAndSortTasksUseCase {
  List<TaskEntity> call({
    required List<TaskEntity> tasks,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    String searchQuery = '',
    TaskSortOption sortOption = TaskSortOption.none,
  }) {
    final query = searchQuery.trim().toLowerCase();

    final filtered = tasks.where((task) {
      if (statusFilter != null && task.status != statusFilter) {
        return false;
      }
      if (priorityFilter != null && task.priority != priorityFilter) {
        return false;
      }
      if (query.isNotEmpty) {
        final matchesTitle = task.title.toLowerCase().contains(query);
        if (!matchesTitle) return false;
      }
      return true;
    }).toList();

    switch (sortOption) {
      case TaskSortOption.none:
        break;
      case TaskSortOption.dueDate:
        filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TaskSortOption.createdAt:
        filtered.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });
        break;
    }

    return filtered;
  }
}
