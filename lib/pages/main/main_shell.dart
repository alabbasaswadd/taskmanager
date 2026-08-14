import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:wallet/core/components/app_alert_dialog.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/pages/auth/sign_in/screen/sign_in_screen.dart';
import 'package:wallet/pages/home/screen/dashboard_screen.dart';
import 'package:wallet/pages/notifications/cubit/notifications_cubit.dart';
import 'package:wallet/pages/notifications/screen/notifications_screen.dart';
import 'package:wallet/pages/projects/cubit/projects_cubit.dart';
import 'package:wallet/pages/projects/model/project_model.dart';
import 'package:wallet/pages/projects/screen/project_form_screen.dart';
import 'package:wallet/pages/projects/screen/projects_screen.dart';
import 'package:wallet/pages/taskes/cubit/tasks_cubit.dart';
import 'package:wallet/pages/taskes/model/task_item_model.dart';
import 'package:wallet/pages/taskes/screen/task_form_screen.dart';
import 'package:wallet/pages/taskes/screen/tasks_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  static const String id = "/home";

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  int _index = 0;
  late final NotificationsCubit _notifications;
  late final ProjectsCubit _projects;
  late final TasksCubit _tasks;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notifications = NotificationsCubit()..refreshUnread();
    _projects = ProjectsCubit()..load();
    _tasks = TasksCubit()..load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _notifications.refreshUnread();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notifications.close();
    _projects.close();
    _tasks.close();
    super.dispose();
  }

  void _goto(int index) => setState(() => _index = index);

  Future<void> _openNotifications() async {
    await Get.to(() => const NotificationsScreen());
    _notifications.refreshUnread();
  }

  void _logout() {
    Get.dialog(
      AppAlertDialog(
        icon: Icons.logout_rounded,
        iconColor: AppColors.kRedColor,
        title: 'هل أنت متأكد من تسجيل الخروج؟',
        content: 'سيتم إنهاء جلسة تسجيل الدخول الحالية.',
        noLabel: 'إلغاء',
        okLabel: 'تسجيل الخروج',
        onNo: Get.back,
        onOk: () async {
          Get.back();
          await UserSession.clear();
          DioFactory.clearToken();
          Get.offAllNamed(SignInScreen.id);
        },
      ),
    );
  }

  Future<void> _openAddScreen() async {
    if (_index == 1) {
      final result = await Get.to<ProjectModel>(() => const ProjectFormScreen());
      if (result != null && mounted) _projects.addProject(result);
    } else if (_index == 2) {
      final result = await Get.to<TaskItemModel>(() => const TaskFormScreen());
      if (result != null && mounted) _tasks.addTask(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titles = ['app_name'.tr, 'projects'.tr, 'tasks'.tr];

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _projects),
        BlocProvider.value(value: _tasks),
      ],
      child: BlocProvider.value(
        value: _notifications,
        child: Scaffold(
          appBar: AppBar(
            title: Text(titles[_index]),
            actions: [
              BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: _openNotifications,
                    tooltip: 'notifications'.tr,
                    icon: Badge(
                      isLabelVisible: state.unreadCount > 0,
                      backgroundColor: colorScheme.primary,
                      label: Text(
                        '${state.unreadCount}',
                        style: const TextStyle(
                          fontFamily: 'Cairo-Bold',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: _logout,
                icon: Icon(Icons.logout_rounded, color: colorScheme.onSurface),
                tooltip: 'logout'.tr,
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: IndexedStack(
            index: _index,
            children: [
              DashboardBody(onNavigate: _goto),
              const ProjectsBody(),
              const TasksBody(),
            ],
          ),
          floatingActionButton: (_index == 1 || _index == 2)
              ? FloatingActionButton(
                  onPressed: _openAddScreen,
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _goto,
            animationDuration: const Duration(milliseconds: 300),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard_rounded),
                label: 'home'.tr,
              ),
              NavigationDestination(
                icon: const Icon(Icons.folder_open_outlined),
                selectedIcon: const Icon(Icons.folder_rounded),
                label: 'projects'.tr,
              ),
              NavigationDestination(
                icon: const Icon(Icons.check_circle_outline_rounded),
                selectedIcon: const Icon(Icons.check_circle_rounded),
                label: 'tasks'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
