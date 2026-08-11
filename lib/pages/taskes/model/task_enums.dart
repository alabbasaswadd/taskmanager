import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/core/constants/colors.dart';

// ─── Task Status ──────────────────────────────────────────────────────────────

enum TaskStatus { notStarted, inProgress, completed, overdue, deferred }

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.notStarted: return 'status_not_started'.tr;
      case TaskStatus.inProgress: return 'status_in_progress'.tr;
      case TaskStatus.completed:  return 'status_completed'.tr;
      case TaskStatus.overdue:    return 'status_overdue'.tr;
      case TaskStatus.deferred:   return 'status_deferred'.tr;
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.notStarted: return AppColors.kStatusNotStarted;
      case TaskStatus.inProgress: return AppColors.kStatusInProgress;
      case TaskStatus.completed:  return AppColors.kStatusCompleted;
      case TaskStatus.overdue:    return AppColors.kStatusOverdue;
      case TaskStatus.deferred:   return AppColors.kStatusDeferred;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.notStarted: return Icons.radio_button_unchecked_rounded;
      case TaskStatus.inProgress: return Icons.timelapse_rounded;
      case TaskStatus.completed:  return Icons.check_circle_rounded;
      case TaskStatus.overdue:    return Icons.warning_amber_rounded;
      case TaskStatus.deferred:   return Icons.pause_circle_outline_rounded;
    }
  }
}

// ─── Task Priority ────────────────────────────────────────────────────────────

enum TaskPriority { low, medium, high, urgent }

extension TaskPriorityX on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:    return 'priority_low'.tr;
      case TaskPriority.medium: return 'priority_medium'.tr;
      case TaskPriority.high:   return 'priority_high'.tr;
      case TaskPriority.urgent: return 'priority_urgent'.tr;
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:    return AppColors.kPriorityLow;
      case TaskPriority.medium: return AppColors.kPriorityMedium;
      case TaskPriority.high:   return AppColors.kPriorityHigh;
      case TaskPriority.urgent: return AppColors.kPriorityUrgent;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:    return Icons.arrow_downward_rounded;
      case TaskPriority.medium: return Icons.drag_handle_rounded;
      case TaskPriority.high:   return Icons.arrow_upward_rounded;
      case TaskPriority.urgent: return Icons.priority_high_rounded;
    }
  }
}
