// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      if (instance.user case final value?) 'user': value,
      if (instance.token case final value?) 'token': value,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      status: json['status'] as String?,
      isAdmin: json['is_admin'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      isPassword: json['is_password'] as String?,
      verifyCode: json['verify_code'] as String?,
      profileImage: json['profile_image'] as String?,
      displayImage: json['display_image'] as String?,
      phone: json['phone'] as String?,
      totalEvents: (json['total_events'] as num?)?.toInt(),
      totalPrices: json['total_event_price'] as String?,
      subscriptionDetail: json['subscription_detail'] == null
          ? null
          : SubscriptionDetail.fromJson(
              json['subscription_detail'] as Map<String, dynamic>),
      totalVehicles: (json['total_vehicles'] as num?)?.toInt(),
    )..date_format = json['date_format'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt,
      'verify_code': instance.verifyCode,
      'is_password': instance.isPassword,
      'status': instance.status,
      'is_admin': instance.isAdmin,
      'created_at': instance.createdAt,
      'date_format': instance.date_format,
      'updated_at': instance.updatedAt,
      'phone': instance.phone,
      'profile_image': instance.profileImage,
      'display_image': instance.displayImage,
      'total_vehicles': instance.totalVehicles,
      'total_events': instance.totalEvents,
      'total_event_price': instance.totalPrices,
      'subscription_detail': instance.subscriptionDetail,
    };

SubscriptionDetail _$SubscriptionDetailFromJson(Map<String, dynamic> json) =>
    SubscriptionDetail(
      itemId: json['item_id'] as String?,
      uniqueIdentifier: json['unique_identifier'] as String?,
      isTrial: (json['is_trial'] as num?)?.toInt(),
      trialEndDate: json['trial_end_date'] as String?,
      isSubscription: (json['is_subscription'] as num?)?.toInt(),
      isSecondTime: (json['is_second_time'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SubscriptionDetailToJson(SubscriptionDetail instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'unique_identifier': instance.uniqueIdentifier,
      'is_trial': instance.isTrial,
      'trial_end_date': instance.trialEndDate,
      'is_subscription': instance.isSubscription,
      'is_second_time': instance.isSecondTime,
    };
