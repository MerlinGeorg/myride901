import 'package:json_annotation/json_annotation.dart';

/// This allows the `ForgotPasswordRequest` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'forgotPasswordRequest.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ForgotPasswordRequest {

  String? code;
  String? email;
  ForgotPasswordRequest(this.code, this.email);

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => _$ForgotPasswordRequestFromJson(json);


  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}