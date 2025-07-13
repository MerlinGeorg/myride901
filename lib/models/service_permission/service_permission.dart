import 'package:json_annotation/json_annotation.dart';

/// This allows the `ServicePermission` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'service_permission.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ServicePermission {
  int? id;
  @JsonKey(name: "service_id")
  String? serviceId;
  @JsonKey(name: "user_email")
  String? userEmail;
  @JsonKey(name: "is_view")
  String? isView;
  @JsonKey(name: "is_edit")
  String? isEdit;
  @JsonKey(name: "is_guest")
  String? isGuest;
  @JsonKey(name: "user_name")
  String? userName;
  @JsonKey(name: "is_check")
  String? isCheck;
  ServicePermission(
      {this.id,
        this.serviceId,
        this.userEmail,
        this.isView,
        this.isEdit,this.isCheck,this.isGuest,this.userName});

  factory ServicePermission.fromJson(Map<String, dynamic> json) => _$ServicePermissionFromJson(json);
  Map<String, dynamic> toJson() => _$ServicePermissionToJson(this);

}
