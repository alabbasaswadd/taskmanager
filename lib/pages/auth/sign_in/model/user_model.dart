/// Mirrors the backend `UserResponse` (`GET /api/users/me`). Manual JSON.
class UserModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final String? email;
  final String? profileImageUrl;
  final bool? isActive;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.displayName,
    this.email,
    this.profileImageUrl,
    this.isActive,
    this.lastLoginAt,
    this.createdAt,
  });

  String get name => (displayName?.trim().isNotEmpty ?? false)
      ? displayName!
      : [firstName, lastName].where((e) => (e ?? '').isNotEmpty).join(' ').trim();

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] ?? '').toString(),
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        displayName: json['displayName'] as String?,
        email: json['email'] as String?,
        profileImageUrl: json['profileImageUrl'] as String?,
        isActive: json['isActive'] as bool?,
        lastLoginAt: json['lastLoginAt'] == null
            ? null
            : DateTime.tryParse(json['lastLoginAt'].toString()),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.tryParse(json['createdAt'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'displayName': displayName,
        'email': email,
        'profileImageUrl': profileImageUrl,
        'isActive': isActive,
        'lastLoginAt': lastLoginAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
      };
}

/// Payload for `PUT /api/users/me`.
class UpdateUserRequest {
  final String firstName;
  final String lastName;
  final String displayName;
  final String? profileImageUrl;

  UpdateUserRequest({
    required this.firstName,
    required this.lastName,
    required this.displayName,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'displayName': displayName,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      };
}
