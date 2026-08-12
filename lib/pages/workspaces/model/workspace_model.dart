/// Mirrors backend `WorkspaceResponse` / `WorkspaceListItem`. Manual JSON.
class WorkspaceModel {
  final String id;
  final String name;
  final String? description;
  final bool? isActive;
  final int? memberCount;
  final DateTime? createdAt;

  WorkspaceModel({
    required this.id,
    required this.name,
    this.description,
    this.isActive,
    this.memberCount,
    this.createdAt,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) => WorkspaceModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        description: json['description'] as String?,
        isActive: json['isActive'] as bool?,
        memberCount: (json['memberCount'] as num?)?.toInt(),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.tryParse(json['createdAt'].toString()),
      );
}

/// Mirrors backend `CreateWorkspaceRequest` ( `{ name, description? }` ).
class CreateWorkspaceRequest {
  final String name;
  final String? description;

  const CreateWorkspaceRequest({required this.name, this.description});

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
      };
}
