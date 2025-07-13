// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      id: (json['id'] as num?)?.toInt(),
      userId: json['user_id'] as String?,
      vehicleId: json['vehicle_id'] as String?,
      category: json['category'] as String?,
      mileageUnit: json['mileageUnit'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      days: json['days'] as String?,
      hours: json['hours'] as String?,
      minutes: json['minutes'] as String?,
      totalDistance: json['total_distance'] as String?,
      startLocation: json['start_location'] as String?,
      endLocation: json['end_location'] as String?,
      price: json['price'] as String?,
      earnings: json['earnings'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'vehicle_id': instance.vehicleId,
      'category': instance.category,
      'mileageUnit': instance.mileageUnit,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'days': instance.days,
      'hours': instance.hours,
      'minutes': instance.minutes,
      'total_distance': instance.totalDistance,
      'start_location': instance.startLocation,
      'end_location': instance.endLocation,
      'price': instance.price,
      'earnings': instance.earnings,
      'notes': instance.notes,
    };
