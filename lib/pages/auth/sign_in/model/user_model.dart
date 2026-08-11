import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final int? role;
  final bool? isActive;
  final String? createdOn;

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.role,
    this.isActive,
    this.createdOn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
