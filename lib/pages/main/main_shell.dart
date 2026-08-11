import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/pages/auth/sign_in/screen/sign_in_screen.dart';
import 'package:wallet/pages/home/screen/dashboard_screen.dart';
import 'package:wallet/pages/notifications/cubit/notifications_cubit.dart';
import 'package:wallet/pages/notifications/screen/notifications_screen.dart';
import 'package:wallet/pages/projects/screen/project_form_screen.dart';
import 'package:wallet/pages/projects/screen/projects_screen.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notifications = NotificationsCubit()..refreshUnread();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _notifications.refreshUnread();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notifications.close();
    super.dispose();
  }

  void _goto(int index) => setState(() => _index = index);

  Future<void> _openNotifications() async {
    await Get.to(() => const NotificationsScreen());
    _notifications.refreshUnread();
  }

  Future<void> _logout() async {
    await UserSession.clear();
    DioFactory.clearToken();
    Get.offAllNamed(SignInScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titles = ['app_name'.tr, 'projects'.tr, 'tasks'.tr];

    return BlocProvider.value(
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
        floatingActionButton: _index == 1
            ? FloatingActionButton(
                onPressed: () => Get.to(() => const ProjectFormScreen()),
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
    );
  }
}
