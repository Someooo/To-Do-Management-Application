import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/config/app_routes.dart';
import 'package:my_template/di.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/empty_tasks_widget.dart';
import '../widgets/task_error_widget.dart';
import '../widgets/task_list_widget.dart';
import '../widgets/task_loading_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
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
          debugPrint('📱 [HomePage] User logged out. Navigating to login...');
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            'TaskFlow',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1C1F),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Color(0xFF1A1C1F)),
              tooltip: 'Logout',
              onPressed: () {
                debugPrint('📱 [HomePage] Logout button pressed');
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
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
                  return const EmptyTasksWidget();
                }
                return TaskListWidget(tasks: state.tasks);
              }

              return const TaskLoadingWidget();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.addTask);
          },
          backgroundColor: const Color(0xFF0060A9),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }
}
