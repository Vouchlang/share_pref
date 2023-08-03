import 'package:json_annotation/json_annotation.dart';
part 'Class_Survey.g.dart';

@JsonSerializable()
class Class_Survey {
  late final String survey_link;

  Class_Survey({
    required this.survey_link,
  });

  factory Class_Survey.fromJson(Map<String, dynamic> json) =>
      _$Class_SurveyFromJson(json);
  Map<String, dynamic> toJson() => _$Class_SurveyToJson(this);
}
