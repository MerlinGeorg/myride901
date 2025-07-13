import 'package:json_annotation/json_annotation.dart';

part 'reminder.g.dart';

@JsonSerializable()
class Reminder {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: 'vehicle_id')
  String? vehicleId;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'service_id')
  String? serviceId;
  @JsonKey(name: 'reminder_date')
  String? reminderDate;
  @JsonKey(name: 'reminder_name')
  String? reminderName;
  String? notes;
  @JsonKey(name: 'timezone')
  String? timezone;

  Reminder(
      {this.id,
      this.vehicleId,
      this.userId,
      this.serviceId,
      this.reminderDate,
      this.reminderName,
      this.notes,
      this.timezone});

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}
