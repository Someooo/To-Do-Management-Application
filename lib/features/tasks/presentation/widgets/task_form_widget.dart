import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_snack_bar.dart';
import '../../domain/entities/task_entity.dart';
import 'due_date_picker_field.dart';
import 'save_task_button.dart';
import 'task_priority_dropdown.dart';
import 'task_status_dropdown.dart';

class TaskFormWidget extends StatefulWidget {
  final ValueChanged<TaskEntity> onSubmit;
  final VoidCallback onCancel;
  final bool isLoading;
  final TaskEntity? initialTask;
  final String submitButtonLabel;

  const TaskFormWidget({
    super.key,
    required this.onSubmit,
    required this.onCancel,
    this.isLoading = false,
    this.initialTask,
    this.submitButtonLabel = 'Create Task',
  });

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  TaskPriority _priority = TaskPriority.low;
  TaskStatus _status = TaskStatus.todo;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask?.title ?? '');
    _descriptionController = TextEditingController(text: widget.initialTask?.description ?? '');
    if (widget.initialTask != null) {
      _priority = widget.initialTask!.priority;
      _status = widget.initialTask!.status;
      _dueDate = widget.initialTask!.dueDate;
    }
    _titleController.addListener(_onTitleChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    final text = _titleController.text;
    if (text.length > 100) {
      AppSnackBar.showError(context, 'Title cannot exceed 100 characters.');
      _titleController.value = TextEditingValue(
        text: text.substring(0, 100),
        selection: const TextSelection.collapsed(offset: 100),
      );
    }
    setState(() {});
  }

  void _onSavePressed() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final task = TaskEntity(
      id: widget.initialTask?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      status: _status,
      dueDate: _dueDate,
      createdAt: widget.initialTask?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSubmit(task);
  }

  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF404752);
    const inputBgColor = Color(0xFFF3F3F7);
    const textColor = Color(0xFF1A1C1F);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'Task Title',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: labelColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          TextFormField(
            controller: _titleController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a task title';
              }
              if (value.length > 100) {
                return 'Title cannot exceed 100 characters';
              }
              return null;
            },
            style: const TextStyle(fontSize: 15, color: textColor),
            decoration: InputDecoration(
              counterText: '${_titleController.text.length}/100',
              counterStyle: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: inputBgColor,
              hintText: 'Enter task title',
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
              prefixIcon: const Icon(
                Icons.title_rounded,
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'Description',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: labelColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a task description';
              }
              return null;
            },
            style: const TextStyle(fontSize: 15, color: textColor),
            decoration: InputDecoration(
              filled: true,
              fillColor: inputBgColor,
              hintText: 'Enter task description',
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Icon(
                  Icons.notes_rounded,
                  color: labelColor,
                  size: 20,
                ),
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 360;
              if (isNarrow) {
                return Column(
                  children: [
                    TaskPriorityDropdown(
                      value: _priority,
                      onChanged: (val) {
                        if (val != null) setState(() => _priority = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    TaskStatusDropdown(
                      value: _status,
                      onChanged: (val) {
                        if (val != null) setState(() => _status = val);
                      },
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: TaskPriorityDropdown(
                      value: _priority,
                      onChanged: (val) {
                        if (val != null) setState(() => _priority = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TaskStatusDropdown(
                      value: _status,
                      onChanged: (val) {
                        if (val != null) setState(() => _status = val);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          DueDatePickerField(
            selectedDate: _dueDate,
            onDateSelected: (date) {
              setState(() => _dueDate = date);
            },
          ),
          const SizedBox(height: 32),

          SaveTaskButton(
            label: widget.submitButtonLabel,
            isLoading: widget.isLoading,
            onPressed: _onSavePressed,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: widget.isLoading ? null : widget.onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
