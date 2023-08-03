import 'package:json_annotation/json_annotation.dart';
part 'Class_Social.g.dart';

@JsonSerializable()
class Class_Social {
  late final String image_url;
  late final String link_url;

  Class_Social({required this.image_url, required this.link_url});

  factory Class_Social.fromJson(Map<String, dynamic> json) =>
      _$Class_SocialFromJson(json);
  Map<String, dynamic> toJson() => _$Class_SocialToJson(this);
}
