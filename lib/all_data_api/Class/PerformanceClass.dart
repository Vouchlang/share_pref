// PerformanceClass.dart
class Performance {
  final String yearName;
  final List<Semester> semesters;

  Performance({
    required this.yearName,
    required this.semesters,
  });
}

class Semester {
  final String semesterName;
  final List<Subject> subjects;

  Semester({
    required this.semesterName,
    required this.subjects,
  });
}

class Subject {
  final String subjectName;
  final List<Attendance> attendance;
  final List<StudyScore> studyScore;

  Subject({
    required this.subjectName,
    required this.attendance,
    required this.studyScore,
  });
}

class Attendance {
  final String late;
  final String absent;
  final String present;
  final double avgAttendance;

  Attendance({
    required this.late,
    required this.absent,
    required this.present,
    required this.avgAttendance,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      late: json['late'],
      absent: json['absent'],
      present: json['present'],
      avgAttendance: json['avg_attendance'].toDouble(),
    );
  }
}

class StudyScore {
  final double avgAttendance;
  final String exercise;
  final String midTerm;
  final String finalScore;
  final double scoreAvgStudyScore;

  StudyScore({
    required this.avgAttendance,
    required this.exercise,
    required this.midTerm,
    required this.finalScore,
    required this.scoreAvgStudyScore,
  });

  factory StudyScore.fromJson(Map<String, dynamic> json) {
    return StudyScore(
      avgAttendance: json['avg_attendance'].toDouble(),
      exercise: json['exercise'],
      midTerm: json['mid_term'],
      finalScore: json['final'],
      scoreAvgStudyScore: json['score_avg_study_score'].toDouble(),
    );
  }
}
