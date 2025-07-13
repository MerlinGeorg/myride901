import 'package:json_annotation/json_annotation.dart';

/// This allows the `Blog` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file password.
part 'blog.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Blog {
  int? id;
  String? title;
  String? url;
  String? image;
  String? date;

  Blog(
      {this.id,
        this.title,this.url,this.date,this.image});

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
  Map<String, dynamic> toJson() => _$BlogToJson(this);

}
