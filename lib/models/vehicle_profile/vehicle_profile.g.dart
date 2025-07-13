// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleProfile _$VehicleProfileFromJson(Map<String, dynamic> json) =>
    VehicleProfile(
      (json['id'] as num?)?.toInt(),
      json['images'] as List<dynamic>?,
      json['year'] as String?,
      json['vin_number'] as String?,
      json['price'] as String?,
      json['selling_price'] as String?,
      json['previous_mileage'] as String?,
      json['previous_date'] as String?,
      json['notes'] as String?,
      json['nick_name'] as String?,
      json['model'] as String?,
      json['make_company'] as String?,
      json['license_plate'] as String?,
      json['engine'] as String?,
      json['drive'] as String?,
      json['current_mileage'] as String?,
      json['current_date'] as String?,
      json['body_trim'] as String?,
      json['currency'] as String?,
      json['mileage_unit'] as String?,
      json['user_id'] as String?,
      (json['service_event_count'] as num?)?.toInt(),
      json['display_name'] as String?,
      (json['is_my_vehicle'] as num?)?.toInt(),
      (json['wallet_cards'] as List<dynamic>?)
          ?.map((e) => WalletCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['type'] as num?)?.toInt(),
      json['total_price'],
      (json['recalls'] as List<dynamic>?)
          ?.map((e) => Recall.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VehicleProfileToJson(VehicleProfile instance) =>
    <String, dynamic>{
      'nick_name': instance.Nickname,
      'vin_number': instance.VIN,
      'license_plate': instance.LicensePlate,
      'make_company': instance.Make,
      'drive': instance.Drive,
      'model': instance.Model,
      'body_trim': instance.Body,
      'year': instance.Year,
      'engine': instance.Engine,
      'previous_date': instance.PDate,
      'current_date': instance.CDate,
      'previous_mileage': instance.PKm,
      'current_mileage': instance.CKm,
      'price': instance.Price,
      'selling_price': instance.SPrice,
      'images': instance.images,
      'notes': instance.note,
      'id': instance.id,
      'mileage_unit': instance.mileageUnit,
      'currency': instance.currency,
      'user_id': instance.userId,
      'service_event_count': instance.serviceEventCount,
      'display_name': instance.displayName,
      'is_my_vehicle': instance.isMyVehicle,
      'wallet_cards': instance.walletCards,
      'total_price': instance.totalPrice,
      'type': instance.type,
      'recalls': instance.recalls,
    };

WalletCard _$WalletCardFromJson(Map<String, dynamic> json) => WalletCard(
      (json['id'] as num?)?.toInt(),
      (json['vehicle_id'] as num?)?.toInt(),
      json['wallet_key'] as String?,
      (json['wallet_key_id'] as num?)?.toInt(),
      json['value'] as String?,
      (json['is_default'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WalletCardToJson(WalletCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle_id': instance.vehicleId,
      'wallet_key': instance.walletKey,
      'wallet_key_id': instance.walletKeyId,
      'value': instance.value,
      'is_default': instance.isDefault,
    };

Recall _$RecallFromJson(Map<String, dynamic> json) => Recall(
      json['desc'] as String?,
      json['corrective_action'] as String?,
      json['consequence'] as String?,
      json['recall_date'] as String?,
      json['campaign_number'] as String?,
      json['recall_number'] as String?,
      json['vinNumber'] as String?,
    );

Map<String, dynamic> _$RecallToJson(Recall instance) => <String, dynamic>{
      'desc': instance.desc,
      'corrective_action': instance.corrective_action,
      'consequence': instance.consequence,
      'recall_date': instance.recall_date,
      'campaign_number': instance.campaign_number,
      'recall_number': instance.recall_number,
      'vinNumber': instance.vinNumber,
    };
