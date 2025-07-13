import 'package:json_annotation/json_annotation.dart';

/// This allows the `CategoryType` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'category_type.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class CategoryType {
  String? id;
  String? name;

  CategoryType(
      {this.id,
        this.name});

  factory CategoryType.fromJson(Map<String, dynamic> json) => _$CategoryTypeFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryTypeToJson(this);

}
