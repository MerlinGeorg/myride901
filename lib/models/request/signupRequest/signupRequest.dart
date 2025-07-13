import 'package:json_annotation/json_annotation.dart';

/// This allows the `SignupRequest` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'signupRequest.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class SignupRequest {

  String? password;
  String? email;
  String? last_name;
  String? first_name;
  SignupRequest(this.password, this.email,this.last_name,this.first_name);

  factory SignupRequest.fromJson(Map<String, dynamic> json) => _$SignupRequestFromJson(json);


  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);
}