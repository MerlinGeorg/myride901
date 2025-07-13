import 'package:json_annotation/json_annotation.dart';

/// This allows the `VehicleProvider` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'service_provider.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class VehicleProvider {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "user_id")
  String? user_id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "address")
  String? address;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "postal_code")
  String? postal_code;
  @JsonKey(name: "province")
  String? province;
  @JsonKey(name: "country")
  String? country;
  @JsonKey(name: "street")
  String? street;

  VehicleProvider(
    this.id,
    this.user_id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.postal_code,
    this.province,
    this.country,
    this.street,
  );

  VehicleProvider.getInstance();

  factory VehicleProvider.fromJson(Map<String, dynamic> json) =>
      _$VehicleProviderFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleProviderToJson(this);
}
