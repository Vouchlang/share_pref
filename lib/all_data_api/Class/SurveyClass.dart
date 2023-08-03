class Survey_Class {
  final String survey_teacher, survey_link;

  Survey_Class({
    required this.survey_teacher,
    required this.survey_link,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'survey_teacher': survey_teacher,
  //     'survey_link': survey_link,
  //   };
  // }

  factory Survey_Class.fromJson(Map<String, dynamic> json) {
    return Survey_Class(
      survey_teacher: json['survey_teacher'] as String,
      survey_link: json['survey_link'] as String,
    );
  }
}
