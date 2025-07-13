// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgotPasswordRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordRequest(
      json['code'] as String?,
      json['email'] as String?,
    );

Map<String, dynamic> _$ForgotPasswordRequestToJson(
        ForgotPasswordRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'email': instance.email,
    };
