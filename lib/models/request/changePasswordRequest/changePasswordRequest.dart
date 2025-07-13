import 'package:json_annotation/json_annotation.dart';

/// This allows the `ChangePasswordRequest` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'changePasswordRequest.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ChangePasswordRequest {

  String? password;
  String? old_password;
  String? password_confirm;
  ChangePasswordRequest(this.password, this.old_password,this.password_confirm);

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordRequestFromJson(json);


  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}