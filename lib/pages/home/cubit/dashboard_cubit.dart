import 'package:bloc/bloc.dart';

import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/pages/notifications/api/notifications_repository.dart';
import 'package:wallet/pages/projects/api/projects_repository.dart';
import 'package:wallet/pages/taskes/api/tasks_repository.dart';

class DashboardState {
  final bool loading;
  final int activeProjects;
  final int pendingTasks;
  final int unreadNotifications;
  final String? error;

  const DashboardState({
    this.loading = true,
    this.activeProjects = 0,
    this.pendingTasks = 0,
    this.unreadNotifications = 0,
    this.error,
  });

  DashboardState copyWith({
    bool? loading,
    int? activeProjects,
    int? pendingTasks,
    int? unreadNotifications,
    String? error,
  }) =>
      DashboardState(
        loading: loading ?? this.loading,
        activeProjects: activeProjects ?? this.activeProjects,
        pendingTasks: pendingTasks ?? this.pendingTasks,
        unreadNotifications: unreadNotifications ?? this.unreadNotifications,
        error: error,
      );
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    ProjectsRepository? projects,
    TasksRepository? tasks,
    NotificationsRepository? notifications,
  })  : _projects = projects ?? ProjectsRepository(),
        _tasks = tasks ?? TasksRepository(),
        _notifications = notifications ?? NotificationsRepository(),
        super(const DashboardState());

  final ProjectsRepository _projects;
  final TasksRepository _tasks;
  final NotificationsRepository _notifications;

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));

    const oneRow = PageParams(pageSize: 1);
    final projectsRes = await _projects.getProjects(page: oneRow, status: ProjectStatus.active);
    final tasksRes = await _tasks.getTasks(page: oneRow, status: TaskItemStatus.todo);
    final unreadRes = await _notifications.unreadCount();

    int active = state.activeProjects, pending = state.pendingTasks, unread = state.unreadNotifications;

    projectsRes.when(success: (p) => active = p.totalCount, failure: (_) {});
    tasksRes.when(success: (p) => pending = p.totalCount, failure: (_) {});
    unreadRes.when(success: (c) => unread = c, failure: (_) {});

    emit(DashboardState(
      loading: false,
      activeProjects: active,
      pendingTasks: pending,
      unreadNotifications: unread,
    ));
  }
}
