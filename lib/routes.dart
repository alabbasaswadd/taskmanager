import 'package:flutter/material.dart';

import 'package:wallet/pages/auth/sign_in/screen/sign_in_screen.dart';
import 'package:wallet/pages/main/main_shell.dart';
import 'package:wallet/pages/projects/screen/project_details_screen.dart';

/// Named routes. Detail/form screens that need typed arguments are pushed with
/// `Get.to(() => Screen(...))`; only stack-clearing / deep-link targets need a
/// named entry here.
Map<String, WidgetBuilder> routes = {
  SignInScreen.id: (context) => const SignInScreen(),
  MainShell.id: (context) => const MainShell(),
  ProjectDetailsScreen.id: (context) => const ProjectDetailsScreen(),
};
