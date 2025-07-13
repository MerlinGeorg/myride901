// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleProvider _$VehicleProviderFromJson(Map<String, dynamic> json) =>
    VehicleProvider(
      (json['id'] as num?)?.toInt(),
      json['user_id'] as String?,
      json['name'] as String?,
      json['email'] as String?,
      json['phone'] as String?,
      json['address'] as String?,
      json['city'] as String?,
      json['postal_code'] as String?,
      json['province'] as String?,
      json['country'] as String?,
      json['street'] as String?,
    );

Map<String, dynamic> _$VehicleProviderToJson(VehicleProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'postal_code': instance.postal_code,
      'province': instance.province,
      'country': instance.country,
      'street': instance.street,
    };
