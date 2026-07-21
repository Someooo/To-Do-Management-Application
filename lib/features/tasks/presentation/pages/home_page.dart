import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/config/app_routes.dart';
import 'package:my_template/core/utils/app_snack_bar.dart';
import 'package:my_template/di.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'edit_task_page.dart';
import '../widgets/delete_task_dialog.dart';
import '../widgets/empty_tasks_widget.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/task_error_widget.dart';
import '../widgets/task_filter_widget.dart';
import '../widgets/task_list_widget.dart';
import '../widgets/task_loading_widget.dart';
import '../widgets/task_search_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => getIt<TaskBloc>()..add(const TaskStarted()),
        ),
      ],
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF9F9FD);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          AppSnackBar.showSuccess(context, 'Signed out successfully.');
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        } else if (state is AuthFailure) {
          AppSnackBar.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: BlocBuilder<TaskBloc, TaskState>(
                      buildWhen: (previous, current) =>
                          current is TaskLoaded || current is TaskInitial,
                      builder: (context, state) {
                        final taskCount =
                            state is TaskLoaded ? state.allTasks.length : 0;
                        return HomeHeaderWidget(taskCount: taskCount);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TaskSearchWidget(
                      onChanged: (newQuery) {
                        context
                            .read<TaskBloc>()
                            .add(TaskSearchChanged(newQuery));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        final statusFilter =
                            state is TaskLoaded ? state.statusFilter : null;
                        final priorityFilter =
                            state is TaskLoaded ? state.priorityFilter : null;

                        return TaskFilterWidget(
                          selectedStatus: statusFilter,
                          selectedPriority: priorityFilter,
                          onStatusChanged: (newStatus) {
                            context.read<TaskBloc>().add(
                                  TaskFilterChanged(
                                    statusFilter: newStatus,
                                    priorityFilter: priorityFilter,
                                  ),
                                );
                          },
                          onPriorityChanged: (newPriority) {
                            context.read<TaskBloc>().add(
                                  TaskFilterChanged(
                                    statusFilter: statusFilter,
                                    priorityFilter: newPriority,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: RefreshIndicator(
                      color: const Color(0xFF3B82F6),
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        context.read<TaskBloc>().add(const TaskRefreshed());
                        await Future.delayed(const Duration(milliseconds: 800));
                      },
                      child: BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, state) {
                          if (state is TaskInitial || state is TaskLoading) {
                            return const TaskLoadingWidget();
                          }

                          if (state is TaskFailure) {
                            return TaskErrorWidget(
                              message: state.message,
                              onRetry: () {
                                context
                                    .read<TaskBloc>()
                                    .add(const TaskSubscriptionRequested());
                              },
                            );
                          }

                          if (state is TaskLoaded) {
                            if (state.tasks.isEmpty) {
                              return const CustomScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  SliverFillRemaining(
                                    child: EmptyTasksWidget(),
                                  ),
                                ],
                              );
                            }
                            return TaskListWidget(
                              tasks: state.tasks,
                              onEditTask: (task) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => EditTaskPage(task: task),
                                  ),
                                );
                              },
                              onDeleteTask: (task) async {
                                final confirmed =
                                    await DeleteTaskDialog.show(context);
                                if (confirmed == true && context.mounted) {
                                  context
                                      .read<TaskBloc>()
                                      .add(TaskDeleted(task.id));
                                  AppSnackBar.showSuccess(
                                    context,
                                    'Task deleted successfully.',
                                  );
                                }
                              },
                            );
                          }

                          return const TaskLoadingWidget();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.addTask);
          },
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }
}
