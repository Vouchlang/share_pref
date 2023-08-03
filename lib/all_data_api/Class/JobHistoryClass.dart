
class JobHistory {
  final String dateStartWork;
  final String workPlace;
  final String position;
  final String salary;

  JobHistory({
    required this.dateStartWork,
    required this.workPlace,
    required this.position,
    required this.salary,
  });

  factory JobHistory.fromJson(Map<String, dynamic> json) {
    return JobHistory(
      dateStartWork: json['date_start_work'],
      workPlace: json['work_place'],
      position: json['position'],
      salary: json['salary'],
    );
  }
}
