// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signupRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupRequest _$SignupRequestFromJson(Map<String, dynamic> json) =>
    SignupRequest(
      json['password'] as String?,
      json['email'] as String?,
      json['last_name'] as String?,
      json['first_name'] as String?,
    );

Map<String, dynamic> _$SignupRequestToJson(SignupRequest instance) =>
    <String, dynamic>{
      'password': instance.password,
      'email': instance.email,
      'last_name': instance.last_name,
      'first_name': instance.first_name,
    };
