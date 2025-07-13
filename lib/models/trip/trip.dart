import 'package:json_annotation/json_annotation.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'vehicle_id')
  String? vehicleId;
  String? category;
  String? mileageUnit;
  @JsonKey(name: 'start_date')
  String? startDate;
  @JsonKey(name: 'end_date')
  String? endDate;
  @JsonKey(name: 'days')
  String? days;
  @JsonKey(name: 'hours')
  String? hours;
  @JsonKey(name: 'minutes')
  String? minutes;
  @JsonKey(name: 'total_distance')
  String? totalDistance;
  @JsonKey(name: 'start_location')
  String? startLocation;
  @JsonKey(name: 'end_location')
  String? endLocation;
  @JsonKey(name: 'price')
  String? price;
  @JsonKey(name: 'earnings')
  String? earnings;
  String? notes;

  Trip({
    this.id,
    this.userId,
    this.vehicleId,
    this.category,
    this.mileageUnit,
    this.startDate,
    this.endDate,
    this.days,
    this.hours,
    this.minutes,
    this.totalDistance,
    this.startLocation,
    this.endLocation,
    this.price,
    this.earnings,
    this.notes,
  });

  Trip.getInstance();

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  Map<String, dynamic> toJson() => _$TripToJson(this);
}
