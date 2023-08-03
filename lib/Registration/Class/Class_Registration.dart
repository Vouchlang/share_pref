class EducationData {
  String title;
  List<EducationDetail> details;

  EducationData({required this.title, required this.details});

  factory EducationData.fromJson(Map<String, dynamic> json) {
    return EducationData(
      title: json['title'],
      details: List<EducationDetail>.from(
          json['details'].map((x) => EducationDetail.fromJson(x))),
    );
  }
}

class EducationDetail {
  String dateTitle;
  List<EducationItem> educationList;
  String timeTitle;
  String timeDetail;

  EducationDetail({
    required this.dateTitle,
    required this.educationList,
    required this.timeTitle,
    required this.timeDetail,
  });

  factory EducationDetail.fromJson(Map<String, dynamic> json) {
    return EducationDetail(
      dateTitle: json['date_title'],
      educationList: List<EducationItem>.from(
          json['education_list'].map((x) => EducationItem.fromJson(x))),
      timeTitle: json['time_title'],
      timeDetail: json['time_detail'],
    );
  }
}

class EducationItem {
  String educationName;
  List<InfoList> infoList;

  EducationItem({required this.educationName, required this.infoList});

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      educationName: json['education_name'],
      infoList: List<InfoList>.from(json['list'].map((x) => x['info'])),
    );
  }
}

class InfoList {
  String info_text;

  InfoList({required this.info_text});

  factory InfoList.fromJson(Map<String, dynamic> json) {
    return InfoList(
      info_text: json['info'],
    );
  }
}
