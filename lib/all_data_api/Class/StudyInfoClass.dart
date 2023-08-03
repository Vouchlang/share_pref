class StudyInfoClass {
  final String date, month, title, subject, room, time;

  StudyInfoClass({
    required this.date,
    required this.month,
    required this.title,
    required this.subject,
    required this.room,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'month': month,
      'title': title,
      'subject': subject,
      'room': room,
      'time': time,
    };
  }

  factory StudyInfoClass.fromJson(Map<String, dynamic> json) {
    return StudyInfoClass(
      date: json['date'],
      month: json['month'],
      title: json['title'],
      subject: json['subject'],
      room: json['room'],
      time: json['time'],
    );
  }
}
