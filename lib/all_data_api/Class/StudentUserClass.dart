class StudentUser {
  final String name_kh, student_id, pwd;

  StudentUser({
    required this.name_kh,
    required this.student_id,
    required this.pwd,
  });

  Map<String, dynamic> toJson() {
    return {
      'name_kh': name_kh,
      'student_id': student_id,
      'pwd': pwd,
    };
  }

  factory StudentUser.fromJson(Map<String, dynamic> json) {
    return StudentUser(
      name_kh: json['name_kh'],
      student_id: json['student_id'],
      pwd: json['pwd'],
    );
  }
}
