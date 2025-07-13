import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:myride901/models/service_permission/service_permission.dart';

/// This allows the `VehicleService` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'vehicle_service.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class VehicleService {
  int? id;
  @JsonKey(name: "vehicle_id")
  String? vehicleId;
  @JsonKey(name: "service_provider_id")
  String? serviceProviderId;
  @JsonKey(name: "vehicle_name")
  String? vehicleName;
  String? title;
  @JsonKey(name: "service_date")
  String? serviceDate;
  String? mileage;
  @JsonKey(name: "detail_1")
  String? detail1;
  @JsonKey(name: "detail_2")
  String? detail2;
  @JsonKey(name: "detail_3")
  String? detail3;
  @JsonKey(name: "created_by")
  String? createdBy;
  @JsonKey(name: "updated_by")
  String? updatedBy;
  String? notes;
  @JsonKey(name: "created_at")
  String? createdAt;
  @JsonKey(name: "vehicle_edit")
  String? vehicleEdit;
  @JsonKey(name: "service_edit")
  String? serviceEdit;
  @JsonKey(name: "total_price")
  String? totalPrice;
  String? avatar;
  @JsonKey(name: "service_permissions")
  List<ServicePermission>? servicePermissions;
  List<Attachments>? attachments;
  List<Details>? details;

  bool? isSelected;

  VehicleService(
      {this.id,
      this.vehicleId,
      this.serviceProviderId,
      this.title,
      this.serviceDate,
      this.mileage,
      this.detail1,
      this.detail2,
      this.detail3,
      this.createdBy,
      this.updatedBy,
      this.notes,
      this.createdAt,
      this.attachments,
      this.details,
      this.servicePermissions,
      this.isSelected,
      this.serviceEdit,
      this.vehicleEdit,
      this.totalPrice,
      this.avatar,
      this.vehicleName});

  factory VehicleService.fromJson(Map<String, dynamic> json) =>
      _$VehicleServiceFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleServiceToJson(this);
}

@JsonSerializable()
class Attachments {
  int? id;
  @JsonKey(name: "service_id")
  String? serviceId;
  String? attachment;
  String? type;
  @JsonKey(name: "created_at")
  String? createdAt;
  @JsonKey(name: "updated_at")
  String? updatedAt;
  @JsonKey(name: "attachment_url")
  dynamic attachmentUrl;
  @JsonKey(name: "doc_type")
  String? docType;
  @JsonKey(name: "extension_name")
  String? extensionName;

  Attachments(
      {this.id,
      this.serviceId,
      this.attachment,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.attachmentUrl,
      this.docType,
      this.extensionName});

  factory Attachments.fromJson(Map<String, dynamic> json) =>
      _$AttachmentsFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentsToJson(this);

  static Map<String, dynamic> toMap(Attachments attachments) => {
        'id': attachments.id,
        'serviceId': attachments.serviceId,
        'attachment': attachments.attachment,
        'type': attachments.type,
        'attachmentUrl': attachments.attachmentUrl,
        'docType': attachments.docType,
        'extensionName': attachments.extensionName,
        'createdAt': attachments.createdAt,
        'updatedAt': attachments.updatedAt,
      };

  static String encode(List<Attachments> addWitnessListModels) => json.encode(
        addWitnessListModels
            .map<Map<String, dynamic>>(
                (addWitnessListModel) => Attachments.toMap(addWitnessListModel))
            .toList(),
      );

  static List<Attachments> decode(String attachments) =>
      (json.decode(attachments) as List<dynamic>)
          .map<Attachments>((item) => Attachments.fromJson(item))
          .toList();
}

@JsonSerializable()
class Details {
  int? id;
  @JsonKey(name: "service_id")
  String? serviceId;
  String? category;
  String? description;
  String? price;
  @JsonKey(name: "category_name")
  String? categoryName;

  Details(
      {this.id,
      this.serviceId,
      this.category,
      this.description,
      this.categoryName,
      this.price});

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}
