// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceChat _$ServiceChatFromJson(Map<String, dynamic> json) => ServiceChat(
      id: (json['id'] as num?)?.toInt(),
      serviceId: json['service_id'] as String?,
      userId: json['user_id'] as String?,
      message: json['message'] as String?,
      createdAt: json['created_at'] as String?,
      userEmail: json['user_email'] as String?,
    );

Map<String, dynamic> _$ServiceChatToJson(ServiceChat instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'user_id': instance.userId,
      'message': instance.message,
      'created_at': instance.createdAt,
      'user_email': instance.userEmail,
    };
