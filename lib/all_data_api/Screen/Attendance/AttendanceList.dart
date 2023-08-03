import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Class/AttendanceClass.dart';
import '../../Class/StudentUserClass.dart';
import 'SubjectDetail.dart';

class AttendanceList extends StatefulWidget {
  final List<StudentUser> data_studentUser;

  AttendanceList({required this.data_studentUser});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List App'),
      ),
      body: _attendanceData == null || _attendanceData!.years.isEmpty
          ? Center(
              child: Text('No Data Display'),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(5),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var yearIndex = 0;
                            yearIndex < _attendanceData!.years.length;
                            yearIndex++)
                          Container(
                            color: _selectedYearIndex == yearIndex
                                ? Colors.blue
                                : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedYearIndex = yearIndex;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  _attendanceData!.years.keys
                                      .elementAt(yearIndex),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedYearIndex == yearIndex
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_selectedYearIndex != -1)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_attendanceData!.years.length > _selectedYearIndex)
                          for (var semesterName in _attendanceData!.years.values
                              .elementAt(_selectedYearIndex)['semesters']
                              .keys)
                            Column(
                              children: [
                                ListTile(
                                  title: Text(semesterName,
                                      textAlign: TextAlign.center),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 75, child: Text('Subject')),
                                      Container(width: 45, child: Text('Hour')),
                                      Container(
                                          width: 45, child: Text('Credit')),
                                      Container(width: 45, child: Text('AWOP')),
                                      Container(width: 45, child: Text('AWP')),
                                      Container(width: 45, child: Text('Late')),
                                      Container(
                                          width: 50, child: Text('Present')),
                                    ],
                                  ),
                                ),
                                ...(_attendanceData!.years.values
                                    .elementAt(_selectedYearIndex)['semesters']
                                        [semesterName]['subjects']
                                    .entries
                                    .map((entry) => SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          NeverScrollableScrollPhysics(),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SubjectDetailsScreen(
                                                subjectName: entry.key,
                                                subjectData: entry.value,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 75,
                                              child: Text(entry.key),
                                            ),
                                            Container(
                                              width: 45,
                                              child: Text(
                                                  entry.value['Hour']),
                                            ),
                                            Container(
                                              width: 45,
                                              child: Text(
                                                  entry.value['Credit']),
                                            ),
                                            Container(
                                              width: 45,
                                              child: Text(
                                                  entry.value['Awop']),
                                            ),
                                            Container(
                                              width: 45,
                                              child: Text(
                                                  entry.value['Awp']),
                                            ),
                                            Container(
                                              width: 45,
                                              child: Text(
                                                  entry.value['Late']),
                                            ),
                                            Container(
                                              width: 50,
                                              child: Text(
                                                  entry.value['Present']),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )))
                              ],
                            )
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
