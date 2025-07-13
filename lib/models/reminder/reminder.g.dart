// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) => Reminder(
      id: (json['id'] as num?)?.toInt(),
      vehicleId: json['vehicle_id'] as String?,
      userId: json['user_id'] as String?,
      serviceId: json['service_id'] as String?,
      reminderDate: json['reminder_date'] as String?,
      reminderName: json['reminder_name'] as String?,
      notes: json['notes'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'id': instance.id,
      'vehicle_id': instance.vehicleId,
      'user_id': instance.userId,
      'service_id': instance.serviceId,
      'reminder_date': instance.reminderDate,
      'reminder_name': instance.reminderName,
      'notes': instance.notes,
      'timezone': instance.timezone,
    };
