import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/app_snack_bar.dart';
import 'package:my_template/di.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_form_widget.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) => getIt<TaskBloc>(),
      child: const _AddTaskPageContent(),
    );
  }
}

class _AddTaskPageContent extends StatefulWidget {
  const _AddTaskPageContent();

  @override
  State<_AddTaskPageContent> createState() => _AddTaskPageContentState();
}

class _AddTaskPageContentState extends State<_AddTaskPageContent> {
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
          'Create Task',
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
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: TaskFormWidget(
                  isLoading: _isSubmitting,
                  onCancel: () => Navigator.of(context).pop(),
                  onSubmit: (task) {
                    setState(() => _isSubmitting = true);
                    context.read<TaskBloc>().add(TaskAdded(task));
                    AppSnackBar.showSuccess(
                        context, 'Task created successfully.');
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
