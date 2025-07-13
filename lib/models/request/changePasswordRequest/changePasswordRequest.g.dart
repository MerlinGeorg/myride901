// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changePasswordRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordRequest _$ChangePasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordRequest(
      json['password'] as String?,
      json['old_password'] as String?,
      json['password_confirm'] as String?,
    );

Map<String, dynamic> _$ChangePasswordRequestToJson(
        ChangePasswordRequest instance) =>
    <String, dynamic>{
      'password': instance.password,
      'old_password': instance.old_password,
      'password_confirm': instance.password_confirm,
    };
