import 'package:json_annotation/json_annotation.dart';

/// This allows the `UserUpdateRequest` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'userUpdateRequest.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class UserUpdateRequest {

  String? last_name;
  String? first_name;
  UserUpdateRequest(this.last_name,this.first_name);

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) => _$UserUpdateRequestFromJson(json);


  Map<String, dynamic> toJson() => _$UserUpdateRequestToJson(this);
}