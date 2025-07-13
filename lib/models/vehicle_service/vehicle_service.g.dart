// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleService _$VehicleServiceFromJson(Map<String, dynamic> json) =>
    VehicleService(
      id: (json['id'] as num?)?.toInt(),
      vehicleId: json['vehicle_id'] as String?,
      serviceProviderId: json['service_provider_id'] as String?,
      title: json['title'] as String?,
      serviceDate: json['service_date'] as String?,
      mileage: json['mileage'] as String?,
      detail1: json['detail_1'] as String?,
      detail2: json['detail_2'] as String?,
      detail3: json['detail_3'] as String?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachments.fromJson(e as Map<String, dynamic>))
          .toList(),
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => Details.fromJson(e as Map<String, dynamic>))
          .toList(),
      servicePermissions: (json['service_permissions'] as List<dynamic>?)
          ?.map((e) => ServicePermission.fromJson(e as Map<String, dynamic>))
          .toList(),
      isSelected: json['isSelected'] as bool?,
      serviceEdit: json['service_edit'] as String?,
      vehicleEdit: json['vehicle_edit'] as String?,
      totalPrice: json['total_price'] as String?,
      avatar: json['avatar'] as String?,
      vehicleName: json['vehicle_name'] as String?,
    );

Map<String, dynamic> _$VehicleServiceToJson(VehicleService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle_id': instance.vehicleId,
      'service_provider_id': instance.serviceProviderId,
      'vehicle_name': instance.vehicleName,
      'title': instance.title,
      'service_date': instance.serviceDate,
      'mileage': instance.mileage,
      'detail_1': instance.detail1,
      'detail_2': instance.detail2,
      'detail_3': instance.detail3,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'vehicle_edit': instance.vehicleEdit,
      'service_edit': instance.serviceEdit,
      'total_price': instance.totalPrice,
      'avatar': instance.avatar,
      'service_permissions': instance.servicePermissions,
      'attachments': instance.attachments,
      'details': instance.details,
      'isSelected': instance.isSelected,
    };

Attachments _$AttachmentsFromJson(Map<String, dynamic> json) => Attachments(
      id: (json['id'] as num?)?.toInt(),
      serviceId: json['service_id'] as String?,
      attachment: json['attachment'] as String?,
      type: json['type'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      attachmentUrl: json['attachment_url'],
      docType: json['doc_type'] as String?,
      extensionName: json['extension_name'] as String?,
    );

Map<String, dynamic> _$AttachmentsToJson(Attachments instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'attachment': instance.attachment,
      'type': instance.type,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'attachment_url': instance.attachmentUrl,
      'doc_type': instance.docType,
      'extension_name': instance.extensionName,
    };

Details _$DetailsFromJson(Map<String, dynamic> json) => Details(
      id: (json['id'] as num?)?.toInt(),
      serviceId: json['service_id'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      categoryName: json['category_name'] as String?,
      price: json['price'] as String?,
    );

Map<String, dynamic> _$DetailsToJson(Details instance) => <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'category': instance.category,
      'description': instance.description,
      'price': instance.price,
      'category_name': instance.categoryName,
    };
