import 'dart:convert';

class AttendanceData {
  final Map<String, dynamic> years;

  AttendanceData({required this.years});

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    final dynamic attendanceDataJson = json['attendance_data'];
    
    Map<String, dynamic> attendanceData = {};

    if (attendanceDataJson is String) {
      attendanceData = jsonDecode(attendanceDataJson);
    } else if (attendanceDataJson is Map<String, dynamic>) {
      attendanceData = attendanceDataJson;
    }

    final yearsData = attendanceData['years'] as Map<String, dynamic>?;

    return AttendanceData(
      years: yearsData ?? {}, // Provide an empty map as a default value
    );
  }
}
