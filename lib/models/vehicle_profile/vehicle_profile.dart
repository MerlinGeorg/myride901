import 'package:json_annotation/json_annotation.dart';

/// This allows the `VehicleProfile` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'vehicle_profile.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class VehicleProfile {
  @JsonKey(name: "nick_name")
  String? Nickname;
  @JsonKey(name: "vin_number")
  String? VIN;
  @JsonKey(name: "license_plate")
  String? LicensePlate;
  @JsonKey(name: "make_company")
  String? Make;
  @JsonKey(name: "drive")
  String? Drive;
  @JsonKey(name: "model")
  String? Model;
  @JsonKey(name: "body_trim")
  String? Body;
  @JsonKey(name: "year")
  String? Year;
  @JsonKey(name: "engine")
  String? Engine;
  @JsonKey(name: "previous_date")
  String? PDate;
  @JsonKey(name: "current_date")
  String? CDate;
  @JsonKey(name: "previous_mileage")
  String? PKm;
  @JsonKey(name: "current_mileage")
  String? CKm;
  @JsonKey(name: "price")
  String? Price;
  @JsonKey(name: "selling_price")
  String? SPrice;
  @JsonKey(name: "images")
  List<dynamic>? images;
  @JsonKey(name: "notes")
  String? note;
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "mileage_unit")
  String? mileageUnit;
  @JsonKey(name: "currency")
  String? currency;
  @JsonKey(name: "user_id")
  String? userId;
  @JsonKey(name: "service_event_count")
  int? serviceEventCount;
  @JsonKey(name: "display_name")
  String? displayName;
  @JsonKey(name: "is_my_vehicle")
  int? isMyVehicle;
  @JsonKey(name: "wallet_cards")
  List<WalletCard>? walletCards;
  @JsonKey(name: "total_price")
  dynamic totalPrice;
  int? type;
  @JsonKey(name: "recalls")
  List<Recall>? recalls;

  VehicleProfile(
    this.id,
    this.images,
    this.Year,
    this.VIN,
    this.Price,
    this.SPrice,
    this.PKm,
    this.PDate,
    this.note,
    this.Nickname,
    this.Model,
    this.Make,
    this.LicensePlate,
    this.Engine,
    this.Drive,
    this.CKm,
    this.CDate,
    this.Body,
    this.currency,
    this.mileageUnit,
    this.userId,
    this.serviceEventCount,
    this.displayName,
    this.isMyVehicle,
    this.walletCards,
    this.type,
    this.totalPrice,
    this.recalls,
  );

  VehicleProfile.getInstance();

  factory VehicleProfile.fromJson(Map<String, dynamic> json) =>
      _$VehicleProfileFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleProfileToJson(this);
}

@JsonSerializable()
class WalletCard {
  int? id;
  @JsonKey(name: "vehicle_id")
  int? vehicleId;
  @JsonKey(name: "wallet_key")
  String? walletKey;
  @JsonKey(name: "wallet_key_id")
  int? walletKeyId;
  String? value;
  @JsonKey(name: "is_default")
  int? isDefault;

  WalletCard(this.id, this.vehicleId, this.walletKey, this.walletKeyId,
      this.value, this.isDefault);

  factory WalletCard.fromJson(Map<String, dynamic> json) =>
      _$WalletCardFromJson(json);

  Map<String, dynamic> toJson() => _$WalletCardToJson(this);

  WalletCard copyWith({
    int? id,
    int? vehicleId,
    String? walletKey,
    int? walletKeyId,
    String? value,
    int? isDefault,
  }) {
    return WalletCard(
      id ?? this.id,
      vehicleId ?? this.vehicleId,
      walletKey ?? this.walletKey,
      walletKeyId ?? this.walletKeyId,
      value ?? this.value,
      isDefault ?? this.isDefault,
    );
  }
}

@JsonSerializable()
class Recall {
  @JsonKey(name: "desc")
  String? desc;
  @JsonKey(name: "corrective_action")
  String? corrective_action;
  @JsonKey(name: "consequence")
  String? consequence;
  @JsonKey(name: "recall_date")
  String? recall_date;
  @JsonKey(name: "campaign_number")
  String? campaign_number;
  @JsonKey(name: "recall_number")
  String? recall_number;
  @JsonKey(name: "vinNumber")
  String? vinNumber;

  Recall(this.desc, this.corrective_action, this.consequence, this.recall_date,
      this.campaign_number, this.recall_number, this.vinNumber);

  factory Recall.fromJson(Map<String, dynamic> json) => _$RecallFromJson(json);

  Map<String, dynamic> toJson() => _$RecallToJson(this);
}
