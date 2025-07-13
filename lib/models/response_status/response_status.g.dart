// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseStatus<T> _$ResponseStatusFromJson<T>(Map<String, dynamic> json) =>
    ResponseStatus<T>(
      error: json['error'] as bool?,
      status_code: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'],
      other_result: json['other_result'],
    );

Map<String, dynamic> _$ResponseStatusToJson<T>(ResponseStatus<T> instance) =>
    <String, dynamic>{
      'error': instance.error,
      'status_code': instance.status_code,
      'message': instance.message,
      'result': instance.result,
      'other_result': instance.other_result,
    };
