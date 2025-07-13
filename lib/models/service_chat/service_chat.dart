import 'package:json_annotation/json_annotation.dart';

/// This allows the `ServiceChat` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'service_chat.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ServiceChat {
  int? id;
  @JsonKey(name: "service_id")
  String? serviceId;
  @JsonKey(name: "user_id")
  String? userId;
  String? message;
  @JsonKey(name: "created_at")
  String? createdAt;
  @JsonKey(name: "user_email")
  String? userEmail;

  ServiceChat(
      {this.id,
        this.serviceId,
        this.userId,
        this.message,
        this.createdAt,
        this.userEmail});

  factory ServiceChat.fromJson(Map<String, dynamic> json) => _$ServiceChatFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceChatToJson(this);

}
