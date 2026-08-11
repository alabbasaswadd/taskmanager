// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SigninRequestModel _$SigninRequestModelFromJson(Map<String, dynamic> json) =>
    SigninRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
      tokenFcm: json['tokenFcm'] as String?,
    );

Map<String, dynamic> _$SigninRequestModelToJson(SigninRequestModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'tokenFcm': instance.tokenFcm,
    };
