import 'package:get/get.dart';

import 'package:wallet/pages/projects/screen/project_details_screen.dart';
import 'package:wallet/pages/taskes/screen/task_details_screen.dart';

/// Routes a notification (in-app tap or FCM tap) to the referenced entity using
/// the backend's loose `referenceType` + `referenceId`. Adding a new target is a
/// single `case`; unknown types are ignored (no hard-coded assumptions).
class NotificationNavigator {
  const NotificationNavigator._();

  static void open({String? referenceType, String? referenceId}) {
    if (referenceId == null || referenceId.isEmpty) return;
    switch (referenceType) {
      case 'TaskItem':
        Get.to(() => TaskDetailsScreen(taskId: referenceId));
        break;
      case 'Project':
        Get.toNamed(ProjectDetailsScreen.id, arguments: referenceId);
        break;
      // Request / Workspace / Note targets: pending their detail screens.
    }
  }
}
