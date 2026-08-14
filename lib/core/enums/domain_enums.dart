import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import '../constants/colors.dart';

// ── Parse helpers (API value → enum), used by the manual model fromJson ──────
// Handles both integer (backend default enum serialization) and string values.
T _parse<T>(List<T> values, String Function(T) api, dynamic raw, T fallback) {
  if (raw == null) return fallback;
  if (raw is int) return raw >= 0 && raw < values.length ? values[raw] : fallback;
  final s = raw.toString();
  for (final v in values) {
    if (api(v) == s) return v;
  }
  return fallback;
}

ProjectStatus projectStatusFromApi(dynamic v) =>
    _parse(ProjectStatus.values, (e) => e.api, v, ProjectStatus.planning);
ProjectPriority projectPriorityFromApi(dynamic v) =>
    _parse(ProjectPriority.values, (e) => e.api, v, ProjectPriority.medium);
TaskItemStatus taskStatusFromApi(dynamic v) =>
    _parse(TaskItemStatus.values, (e) => e.api, v, TaskItemStatus.todo);
TaskPriority taskPriorityFromApi(dynamic v) =>
    _parse(TaskPriority.values, (e) => e.api, v, TaskPriority.medium);
RequestStatus requestStatusFromApi(dynamic v) =>
    _parse(RequestStatus.values, (e) => e.api, v, RequestStatus.pending);
RequestPriority requestPriorityFromApi(dynamic v) =>
    _parse(RequestPriority.values, (e) => e.api, v, RequestPriority.medium);
WorkspaceRole workspaceRoleFromApi(dynamic v) =>
    _parse(WorkspaceRole.values, (e) => e.api, v, WorkspaceRole.member);
NotificationType notificationTypeFromApi(dynamic v) => _parse(
    NotificationType.values,
    (e) => _notificationApi[e]!,
    v,
    NotificationType.general);

const Map<NotificationType, String> _notificationApi = {
  NotificationType.general: 'General',
  NotificationType.taskAssigned: 'TaskAssigned',
  NotificationType.taskUpdated: 'TaskUpdated',
  NotificationType.taskCompleted: 'TaskCompleted',
  NotificationType.taskCommentAdded: 'TaskCommentAdded',
  NotificationType.projectCreated: 'ProjectCreated',
  NotificationType.projectUpdated: 'ProjectUpdated',
  NotificationType.requestReceived: 'RequestReceived',
  NotificationType.requestStatusChanged: 'RequestStatusChanged',
  NotificationType.noteShared: 'NoteShared',
  NotificationType.workspaceInvitation: 'WorkspaceInvitation',
  NotificationType.mention: 'Mention',
};

// Backend stores enums as their PascalCase names (e.g. "Planning", "InProgress").
// @JsonValue keeps JSON (de)serialization aligned with the API; the label/color
// extensions drive the UI. Localization keys resolve via GetX `.tr`.

// ─── Project ────────────────────────────────────────────────────────────────
enum ProjectStatus {
  @JsonValue('Planning') planning,
  @JsonValue('Active') active,
  @JsonValue('OnHold') onHold,
  @JsonValue('Completed') completed,
  @JsonValue('Archived') archived,
}

extension ProjectStatusX on ProjectStatus {
  String get api => const {
        ProjectStatus.planning: 'Planning',
        ProjectStatus.active: 'Active',
        ProjectStatus.onHold: 'OnHold',
        ProjectStatus.completed: 'Completed',
        ProjectStatus.archived: 'Archived',
      }[this]!;
  String get label => 'project_status_${name}'.tr;
  Color get color => switch (this) {
        ProjectStatus.planning => AppColors.kStatusNotStarted,
        ProjectStatus.active => AppColors.kStatusInProgress,
        ProjectStatus.onHold => AppColors.kWarningColor,
        ProjectStatus.completed => AppColors.kStatusCompleted,
        ProjectStatus.archived => AppColors.kGreyColor,
      };
}

enum ProjectPriority {
  @JsonValue('Low') low,
  @JsonValue('Medium') medium,
  @JsonValue('High') high,
  @JsonValue('Critical') critical,
}

extension ProjectPriorityX on ProjectPriority {
  String get api => const {
        ProjectPriority.low: 'Low',
        ProjectPriority.medium: 'Medium',
        ProjectPriority.high: 'High',
        ProjectPriority.critical: 'Critical',
      }[this]!;
  String get label => 'priority_${name}'.tr;
  Color get color => switch (this) {
        ProjectPriority.low => AppColors.kPriorityLow,
        ProjectPriority.medium => AppColors.kPriorityMedium,
        ProjectPriority.high => AppColors.kPriorityHigh,
        ProjectPriority.critical => AppColors.kPriorityUrgent,
      };
}

// ─── Task ─────────────────────────────────────────────────────────────────
enum TaskItemStatus {
  @JsonValue('Todo') todo,
  @JsonValue('InProgress') inProgress,
  @JsonValue('Blocked') blocked,
  @JsonValue('Completed') completed,
  @JsonValue('Cancelled') cancelled,
}

extension TaskItemStatusX on TaskItemStatus {
  String get api => const {
        TaskItemStatus.todo: 'Todo',
        TaskItemStatus.inProgress: 'InProgress',
        TaskItemStatus.blocked: 'Blocked',
        TaskItemStatus.completed: 'Completed',
        TaskItemStatus.cancelled: 'Cancelled',
      }[this]!;
  String get label => 'task_status_${name}'.tr;
  Color get color => switch (this) {
        TaskItemStatus.todo => AppColors.kStatusNotStarted,
        TaskItemStatus.inProgress => AppColors.kStatusInProgress,
        TaskItemStatus.blocked => AppColors.kStatusOverdue,
        TaskItemStatus.completed => AppColors.kStatusCompleted,
        TaskItemStatus.cancelled => AppColors.kGreyColor,
      };
  IconData get icon => switch (this) {
        TaskItemStatus.todo => Icons.radio_button_unchecked_rounded,
        TaskItemStatus.inProgress => Icons.timelapse_rounded,
        TaskItemStatus.blocked => Icons.block_rounded,
        TaskItemStatus.completed => Icons.check_circle_rounded,
        TaskItemStatus.cancelled => Icons.cancel_rounded,
      };
}

enum TaskPriority {
  @JsonValue('Low') low,
  @JsonValue('Medium') medium,
  @JsonValue('High') high,
  @JsonValue('Urgent') urgent,
}

extension TaskPriorityX on TaskPriority {
  String get api => const {
        TaskPriority.low: 'Low',
        TaskPriority.medium: 'Medium',
        TaskPriority.high: 'High',
        TaskPriority.urgent: 'Urgent',
      }[this]!;
  String get label => 'priority_${name}'.tr;
  Color get color => switch (this) {
        TaskPriority.low => AppColors.kPriorityLow,
        TaskPriority.medium => AppColors.kPriorityMedium,
        TaskPriority.high => AppColors.kPriorityHigh,
        TaskPriority.urgent => AppColors.kPriorityUrgent,
      };
}

// ─── Request ────────────────────────────────────────────────────────────────
enum RequestStatus {
  @JsonValue('Pending') pending,
  @JsonValue('InProgress') inProgress,
  @JsonValue('Completed') completed,
  @JsonValue('Rejected') rejected,
  @JsonValue('Cancelled') cancelled,
}

extension RequestStatusX on RequestStatus {
  String get api => const {
        RequestStatus.pending: 'Pending',
        RequestStatus.inProgress: 'InProgress',
        RequestStatus.completed: 'Completed',
        RequestStatus.rejected: 'Rejected',
        RequestStatus.cancelled: 'Cancelled',
      }[this]!;
  String get label => 'request_status_${name}'.tr;
  Color get color => switch (this) {
        RequestStatus.pending => AppColors.kWarningColor,
        RequestStatus.inProgress => AppColors.kStatusInProgress,
        RequestStatus.completed => AppColors.kStatusCompleted,
        RequestStatus.rejected => AppColors.kStatusOverdue,
        RequestStatus.cancelled => AppColors.kGreyColor,
      };
}

enum RequestPriority {
  @JsonValue('Low') low,
  @JsonValue('Medium') medium,
  @JsonValue('High') high,
  @JsonValue('Urgent') urgent,
}

extension RequestPriorityX on RequestPriority {
  String get api => const {
        RequestPriority.low: 'Low',
        RequestPriority.medium: 'Medium',
        RequestPriority.high: 'High',
        RequestPriority.urgent: 'Urgent',
      }[this]!;
  String get label => 'priority_${name}'.tr;
  Color get color => switch (this) {
        RequestPriority.low => AppColors.kPriorityLow,
        RequestPriority.medium => AppColors.kPriorityMedium,
        RequestPriority.high => AppColors.kPriorityHigh,
        RequestPriority.urgent => AppColors.kPriorityUrgent,
      };
}

// ─── Workspace membership ─────────────────────────────────────────────────
enum WorkspaceRole {
  @JsonValue('Owner') owner,
  @JsonValue('Admin') admin,
  @JsonValue('Member') member,
}

extension WorkspaceRoleX on WorkspaceRole {
  String get api => const {
        WorkspaceRole.owner: 'Owner',
        WorkspaceRole.admin: 'Admin',
        WorkspaceRole.member: 'Member',
      }[this]!;
  String get label => 'role_${name}'.tr;
}

// ─── Notifications ──────────────────────────────────────────────────────────
enum NotificationType {
  @JsonValue('General') general,
  @JsonValue('TaskAssigned') taskAssigned,
  @JsonValue('TaskUpdated') taskUpdated,
  @JsonValue('TaskCompleted') taskCompleted,
  @JsonValue('TaskCommentAdded') taskCommentAdded,
  @JsonValue('ProjectCreated') projectCreated,
  @JsonValue('ProjectUpdated') projectUpdated,
  @JsonValue('RequestReceived') requestReceived,
  @JsonValue('RequestStatusChanged') requestStatusChanged,
  @JsonValue('NoteShared') noteShared,
  @JsonValue('WorkspaceInvitation') workspaceInvitation,
  @JsonValue('Mention') mention,
}

extension NotificationTypeX on NotificationType {
  IconData get icon => switch (this) {
        NotificationType.taskAssigned ||
        NotificationType.taskUpdated ||
        NotificationType.taskCompleted ||
        NotificationType.taskCommentAdded =>
          Icons.check_circle_outline_rounded,
        NotificationType.projectCreated ||
        NotificationType.projectUpdated =>
          Icons.folder_open_rounded,
        NotificationType.requestReceived ||
        NotificationType.requestStatusChanged =>
          Icons.assignment_outlined,
        NotificationType.noteShared => Icons.sticky_note_2_outlined,
        NotificationType.workspaceInvitation => Icons.groups_outlined,
        NotificationType.mention => Icons.alternate_email_rounded,
        NotificationType.general => Icons.notifications_none_rounded,
      };
}

enum ActivityAction {
  @JsonValue('Created') created,
  @JsonValue('Updated') updated,
  @JsonValue('Deleted') deleted,
  @JsonValue('StatusChanged') statusChanged,
  @JsonValue('Assigned') assigned,
  @JsonValue('Unassigned') unassigned,
  @JsonValue('Completed') completed,
  @JsonValue('Commented') commented,
  @JsonValue('Archived') archived,
}
