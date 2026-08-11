// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SigninModel _$SigninModelFromJson(Map<String, dynamic> json) => SigninModel(
  token: json['token'] as String?,
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SigninModelToJson(SigninModel instance) =>
    <String, dynamic>{'token': instance.token, 'user': instance.user};
