import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Class/AttendanceClass.dart';
import '../../Class/StudentUserClass.dart';
import 'AttendanceList.dart';
import 'SubjectDetail.dart';

class AttendanceScreen extends StatefulWidget {
  final List<StudentUser> data_studentUser;

  const AttendanceScreen({
    Key? key,
    required this.data_studentUser,
  }) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  AttendanceData? _attendanceData;
  int _selectedYearIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    var response = await http.post(
      Uri.parse(
          'http://192.168.1.51/hosting_api/Test_student/st_attendance_testing.php'),
      body: {
        'student_id': widget.data_studentUser[0].student_id,
        'pwd': widget.data_studentUser[0].pwd,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _attendanceData = AttendanceData.fromJson(jsonDecode(response.body));
      });
    } else {
      // Handle error if needed
      print('Failed to load data: ${response.statusCode}');
    }
  }

  // Function to get the data of the last semester of the last year
  Map<String, dynamic> getLastSemesterData() {
    if (_attendanceData != null && _attendanceData!.years.isNotEmpty) {
      final lastYearName = _attendanceData!.years.keys.last;
      final lastSemesterName =
          _attendanceData!.years[lastYearName]!['semesters'].keys.last;

      return _attendanceData!.years[lastYearName]!['semesters']
          [lastSemesterName]['subjects'];
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final lastSemesterData = getLastSemesterData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance App'),
      ),
      body: _attendanceData == null || _attendanceData!.years.isEmpty
          ? Center(
              child: Text('No Data'),
            )
          : SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 75, child: Text('Subejct')),
                        Container(width: 45, child: Text('Hour')),
                        Container(width: 45, child: Text('Credit')),
                        Container(width: 45, child: Text('AWOP')),
                        Container(width: 45, child: Text('AWP')),
                        Container(width: 45, child: Text('Late')),
                        Container(width: 50, child: Text('Present')),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var entry in lastSemesterData.entries)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectDetailsScreen(
                                subjectName: entry.key,
                                subjectData: entry.value,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 75, child: Text(entry.key)),
                            Container(
                                width: 45, child: Text(entry.value['Hour'])),
                            Container(
                                width: 45, child: Text(entry.value['Credit'])),
                            Container(
                                width: 45, child: Text(entry.value['Awop'])),
                            Container(
                                width: 45, child: Text(entry.value['Awp'])),
                            Container(
                                width: 45, child: Text(entry.value['Late'])),
                            Container(
                                width: 50, child: Text(entry.value['Present'])),
                          ],
                        ),
                      ),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(AttendanceList(
                            data_studentUser: widget.data_studentUser,
                          ));
                        },
                        child: Text('See All'))
                  ],
                ),
              ),
            ),
    );
  }
}
