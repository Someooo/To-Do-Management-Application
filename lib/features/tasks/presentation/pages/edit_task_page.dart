import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/app_snack_bar.dart';
import 'package:my_template/di.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_form_widget.dart';

class EditTaskPage extends StatelessWidget {
  final TaskEntity task;

  const EditTaskPage({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) => getIt<TaskBloc>(),
      child: _EditTaskPageContent(task: task),
    );
  }
}

class _EditTaskPageContent extends StatefulWidget {
  final TaskEntity task;

  const _EditTaskPageContent({required this.task});

  @override
  State<_EditTaskPageContent> createState() => _EditTaskPageContentState();
}

class _EditTaskPageContentState extends State<_EditTaskPageContent> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF9F9FD);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Task',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1C1F),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskFailure) {
              setState(() => _isSubmitting = false);
              AppSnackBar.showError(context, state.message);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TaskFormWidget(
              initialTask: widget.task,
              submitButtonLabel: 'Update Task',
              isLoading: _isSubmitting,
              onCancel: () => Navigator.of(context).pop(),
              onSubmit: (updatedTask) {
                setState(() => _isSubmitting = true);
                context.read<TaskBloc>().add(TaskUpdated(updatedTask));
                AppSnackBar.showSuccess(context, 'Task updated successfully.');
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}
