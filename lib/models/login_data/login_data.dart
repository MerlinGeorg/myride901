import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginData {
  @JsonKey(name: "user")
  User? user;
  @JsonKey(name: "token")
  String? token;

  LoginData({this.user, this.token});

  /// Converts Json string to Map Object
  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  /// Converts Object to Json String
  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "first_name")
  String? firstName;
  @JsonKey(name: "last_name")
  String? lastName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "email_verified_at")
  String? emailVerifiedAt;
  @JsonKey(name: "verify_code")
  String? verifyCode;
  @JsonKey(name: "is_password")
  String? isPassword;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "is_admin")
  String? isAdmin;
  @JsonKey(name: "created_at")
  String? createdAt;
  @JsonKey(name: "date_format")
  String? date_format;
  @JsonKey(name: "updated_at")
  String? updatedAt;
  String? phone;
  @JsonKey(name: "profile_image")
  String? profileImage;
  @JsonKey(name: "display_image")
  String? displayImage;
  @JsonKey(name: "total_vehicles")
  int? totalVehicles;
  @JsonKey(name: "total_events")
  int? totalEvents;
  @JsonKey(name: "total_event_price")
  String? totalPrices;
  @JsonKey(name: "subscription_detail")
  SubscriptionDetail? subscriptionDetail;
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.status,
    this.isAdmin,
    this.createdAt,
    this.updatedAt,
    this.isPassword,
    this.verifyCode,
    this.profileImage,
    this.displayImage,
    this.phone,
    this.totalEvents,
    this.totalPrices,
    this.subscriptionDetail,
    this.totalVehicles,
  });

  /// Converts Json string to Map Object
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts Object to Json String
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class SubscriptionDetail {
  @JsonKey(name: "item_id")
  String? itemId;
  @JsonKey(name: "unique_identifier")
  String? uniqueIdentifier;

  @JsonKey(name: "is_trial")
  int? isTrial;
  @JsonKey(name: "trial_end_date")
  String? trialEndDate;
  @JsonKey(name: "is_subscription")
  int? isSubscription;
  @JsonKey(name: "is_second_time")
  int? isSecondTime;
  SubscriptionDetail({
    this.itemId,
    this.uniqueIdentifier,
    this.isTrial,
    this.trialEndDate,
    this.isSubscription,
    this.isSecondTime,
  });

  /// Converts Json string to Map Object
  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDetailFromJson(json);

  /// Converts Object to Json String
  Map<String, dynamic> toJson() => _$SubscriptionDetailToJson(this);
}
