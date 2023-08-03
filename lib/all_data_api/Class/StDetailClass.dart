class StDetail {
  final String faculty_name;
  final String degree_name;
  final String major_name;
  final String year_name;
  final String semester_name;
  final String name_kh;
  final String name_en;
  final String student_id;
  final String stage_name;
  final String term_name;
  final String academic_year;
  final String shift_name;
  final String room_name;
  final String status_name;
  final String date_of_birth;
  final String phone_number;
  final String profile_pic;
  final String job;
  final String work_place;

  StDetail({
    required this.faculty_name,
    required this.degree_name,
    required this.major_name,
    required this.year_name,
    required this.semester_name,
    required this.name_kh,
    required this.name_en,
    required this.student_id,
    required this.stage_name,
    required this.term_name,
    required this.academic_year,
    required this.shift_name,
    required this.room_name,
    required this.status_name,
    required this.date_of_birth,
    required this.phone_number,
    required this.profile_pic,
    required this.job,
    required this.work_place,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'faculty_name': faculty_name,
  //     'degree_name': degree_name,
  //     'major_name': major_name,
  //     'year_name': year_name,
  //     'semester_name': semester_name,
  //     'name_kh': name_kh,
  //     'name_en': name_en,
  //     'student_id': student_id,
  //     'stage_name': stage_name,
  //     'term_name': term_name,
  //     'academic_year': academic_year,
  //     'shift_name': shift_name,
  //     'room_name': room_name,
  //     'status_name': status_name,
  //     'date_of_birth': date_of_birth,
  //     'phone_number': phone_number,
  //     'profile_pic': profile_pic,
  //     'job': job,
  //     'work_place': work_place
  //   };
  // }

  factory StDetail.fromJson(Map<String, dynamic> json) {
    return StDetail(
      faculty_name: json['faculty_name'],
      degree_name: json['degree_name'],
      major_name: json['major_name'],
      year_name: json['year_name'],
      semester_name: json['semester_name'],
      name_kh: json['name_kh'],
      name_en: json['name_en'],
      student_id: json['student_id'],
      stage_name: json['stage_name'],
      term_name: json['term_name'],
      academic_year: json['academic_year'],
      shift_name: json['shift_name'],
      room_name: json['room_name'],
      status_name: json['status_name'],
      date_of_birth: json['date_of_birth'],
      phone_number: json['phone_number'],
      profile_pic: json['profile_pic'],
      job: json['job'],
      work_place: json['work_place'],
    );
  }
}
