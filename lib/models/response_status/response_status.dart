import 'package:json_annotation/json_annotation.dart';
part 'response_status.g.dart';

@JsonSerializable()
class ResponseStatus<T> {
  bool? error;
  int? status_code;
  String? message;
  dynamic result;
  Object? other_result;

  ResponseStatus(
      {this.error,
      this.status_code,
      this.message,
      this.result,
      this.other_result});

  /// Converts Json string to Map Object
  factory ResponseStatus.fromJson(Map<String, dynamic> json) =>
      _$ResponseStatusFromJson<T>(json);

  /// Converts Object to Json String
  Map<String, dynamic> toJson() => _$ResponseStatusToJson<T>(this);
}
