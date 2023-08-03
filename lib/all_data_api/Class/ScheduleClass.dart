class ScheduleClass {
  final String weekday, date, subject, classroom, teacherName, tel;

  ScheduleClass({
    required this.weekday,
    required this.date,
    required this.subject,
    required this.classroom,
    required this.teacherName,
    required this.tel,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'weekday': weekday,
  //     'date': date,
  //     'subject': subject,
  //     'classroom': classroom,
  //     'teacherName': teacherName,
  //     'tel': tel,
  //   };
  // }

  factory ScheduleClass.fromJson(Map<String, dynamic> json) {
    return ScheduleClass(
      weekday: json['weekday'],
      date: json['date'],
      subject: json['subject'],
      classroom: json['classroom'],
      teacherName: json['teacherName'],
      tel: json['tel'],
    );
  }
}
