import 'package:json_annotation/json_annotation.dart';
part 'Class_ImageSlide.g.dart';

@JsonSerializable()
class Class_Image {
  late final String image_url;

  Class_Image({required this.image_url});

  factory Class_Image.fromJson(Map<String, dynamic> json) =>
      _$Class_ImageFromJson(json);
  Map<String, dynamic> toJson() => _$Class_ImageToJson(this);
}
