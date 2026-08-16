import 'package:wallet/core/enums/domain_enums.dart';

/// Mirrors backend `NotificationResponse`. Manual JSON.
class NotificationModel {
  final String id;
  final String workspaceId;
  final NotificationType type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? readAt;

  /// Loose reference for navigation (e.g. "TaskItem", "Project", "Request").
  final String? referenceType;
  final String? referenceId;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.workspaceId,
    this.type = NotificationType.general,
    required this.title,
    required this.message,
    this.isRead = false,
    this.readAt,
    this.referenceType,
    this.referenceId,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: (json['id'] ?? '').toString(),
        workspaceId: (json['workspaceId'] ?? '').toString(),
        type: notificationTypeFromApi(json['type']),
        title: (json['title'] ?? '').toString(),
        message: (json['message'] ?? '').toString(),
        isRead: json['isRead'] as bool? ?? false,
        readAt: json['readAt'] == null ? null : DateTime.tryParse(json['readAt'].toString()),
        referenceType: json['referenceType'] as String?,
        referenceId: json['referenceId']?.toString(),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.tryParse(json['createdAt'].toString()),
      );
}
