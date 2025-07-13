// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServicePermission _$ServicePermissionFromJson(Map<String, dynamic> json) =>
    ServicePermission(
      id: (json['id'] as num?)?.toInt(),
      serviceId: json['service_id'] as String?,
      userEmail: json['user_email'] as String?,
      isView: json['is_view'] as String?,
      isEdit: json['is_edit'] as String?,
      isCheck: json['is_check'] as String?,
      isGuest: json['is_guest'] as String?,
      userName: json['user_name'] as String?,
    );

Map<String, dynamic> _$ServicePermissionToJson(ServicePermission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'user_email': instance.userEmail,
      'is_view': instance.isView,
      'is_edit': instance.isEdit,
      'is_guest': instance.isGuest,
      'user_name': instance.userName,
      'is_check': instance.isCheck,
    };
