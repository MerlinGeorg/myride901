import 'package:json_annotation/json_annotation.dart';

/// This allows the `LoginRequest` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'loginRequest.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class LoginRequest {

  String? password;
  String? email;
  LoginRequest(this.password, this.email);

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);


  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}