import 'package:wallet/core/enums/domain_enums.dart';

DateTime? _dt(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());

/// Mirrors backend `ProjectResponse` / `ProjectListItem`. Manual JSON.
class ProjectModel {
  final String id;
  final String workspaceId;
  final String name;
  final String? description;
  final ProjectStatus status;
  final ProjectPriority priority;
  final String? ownerId;
  final String? ownerDisplayName;
  final DateTime? startDate;
  final DateTime? targetDate;
  final int? taskCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProjectModel({
    required this.id,
    required this.workspaceId,
    required this.name,
    this.description,
    this.status = ProjectStatus.planning,
    this.priority = ProjectPriority.medium,
    this.ownerId,
    this.ownerDisplayName,
    this.startDate,
    this.targetDate,
    this.taskCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: (json['id'] ?? '').toString(),
        workspaceId: (json['workspaceId'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        description: json['description'] as String?,
        status: projectStatusFromApi(json['status'] as String?),
        priority: projectPriorityFromApi(json['priority'] as String?),
        ownerId: json['ownerId'] as String?,
        ownerDisplayName: json['ownerDisplayName'] as String?,
        startDate: _dt(json['startDate']),
        targetDate: _dt(json['targetDate']),
        taskCount: (json['taskCount'] as num?)?.toInt(),
        createdAt: _dt(json['createdAt']),
        updatedAt: _dt(json['updatedAt']),
      );
}

class CreateProjectRequest {
  final String workspaceId;
  final String name;
  final String? description;
  final ProjectPriority priority;
  final String? ownerId;
  final DateTime? startDate;
  final DateTime? targetDate;

  CreateProjectRequest({
    required this.workspaceId,
    required this.name,
    this.description,
    this.priority = ProjectPriority.medium,
    this.ownerId,
    this.startDate,
    this.targetDate,
  });

  Map<String, dynamic> toJson() => {
        'workspaceId': workspaceId,
        'name': name,
        if (description != null) 'description': description,
        'priority': priority.api,
        if (ownerId != null) 'ownerId': ownerId,
        if (startDate != null) 'startDate': startDate!.toIso8601String(),
        if (targetDate != null) 'targetDate': targetDate!.toIso8601String(),
      };
}

class UpdateProjectRequest {
  final String name;
  final String? description;
  final ProjectPriority priority;
  final String? ownerId;
  final DateTime? startDate;
  final DateTime? targetDate;

  UpdateProjectRequest({
    required this.name,
    this.description,
    this.priority = ProjectPriority.medium,
    this.ownerId,
    this.startDate,
    this.targetDate,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        'priority': priority.api,
        if (ownerId != null) 'ownerId': ownerId,
        if (startDate != null) 'startDate': startDate!.toIso8601String(),
        if (targetDate != null) 'targetDate': targetDate!.toIso8601String(),
      };
}
