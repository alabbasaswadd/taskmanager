import 'package:wallet/core/enums/domain_enums.dart';

DateTime? _dt(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());

/// Mirrors backend `TaskResponse` (detail) and `TaskListItem` (list). Manual JSON.
class TaskItemModel {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final TaskItemStatus status;
  final TaskPriority priority;
  final String? createdById;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final List<TaskAssigneeModel>? assignees;
  final int? assigneeCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskItemModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    this.status = TaskItemStatus.todo,
    this.priority = TaskPriority.medium,
    this.createdById,
    this.dueDate,
    this.completedAt,
    this.assignees,
    this.assigneeCount,
    this.createdAt,
    this.updatedAt,
  });

  int get assigneesTotal => assigneeCount ?? assignees?.length ?? 0;

  TaskItemModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    TaskItemStatus? status,
    TaskPriority? priority,
    String? createdById,
    DateTime? dueDate,
    DateTime? completedAt,
    List<TaskAssigneeModel>? assignees,
    int? assigneeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      TaskItemModel(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        title: title ?? this.title,
        description: description ?? this.description,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        createdById: createdById ?? this.createdById,
        dueDate: dueDate ?? this.dueDate,
        completedAt: completedAt ?? this.completedAt,
        assignees: assignees ?? this.assignees,
        assigneeCount: assigneeCount ?? this.assigneeCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory TaskItemModel.fromJson(Map<String, dynamic> json) => TaskItemModel(
        id: (json['id'] ?? '').toString(),
        projectId: (json['projectId'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        description: json['description'] as String?,
        status: taskStatusFromApi(json['status']),
        priority: taskPriorityFromApi(json['priority']),
        createdById: json['createdById'] as String?,
        dueDate: _dt(json['dueDate']),
        completedAt: _dt(json['completedAt']),
        assignees: (json['assignees'] as List?)
            ?.whereType<Map>()
            .map((e) => TaskAssigneeModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        assigneeCount: (json['assigneeCount'] as num?)?.toInt(),
        createdAt: _dt(json['createdAt']),
        updatedAt: _dt(json['updatedAt']),
      );
}

class TaskAssigneeModel {
  final String userId;
  final String? displayName;
  final DateTime? assignedAt;

  TaskAssigneeModel({required this.userId, this.displayName, this.assignedAt});

  factory TaskAssigneeModel.fromJson(Map<String, dynamic> json) => TaskAssigneeModel(
        userId: (json['userId'] ?? '').toString(),
        displayName: json['displayName'] as String?,
        assignedAt: _dt(json['assignedAt']),
      );
}

class CreateTaskRequest {
  final String projectId;
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;

  CreateTaskRequest({
    required this.projectId,
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.dueDate,
  });

  Map<String, dynamic> toJson() => {
        'projectId': projectId,
        'title': title,
        if (description != null) 'description': description,
        'priority': priority.index,
        if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      };
}

class UpdateTaskRequest {
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;

  UpdateTaskRequest({
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.dueDate,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description != null) 'description': description,
        'priority': priority.index,
        if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      };
}
