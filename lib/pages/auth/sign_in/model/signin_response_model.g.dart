// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SigninResponseModel _$SigninResponseModelFromJson(Map<String, dynamic> json) =>
    SigninResponseModel(
      succeeded: json['succeeded'] as bool?,
      data: json['data'] == null
          ? null
          : SigninModel.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] == null
          ? null
          : ErrorModel.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SigninResponseModelToJson(
  SigninResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'error': instance.error,
};
