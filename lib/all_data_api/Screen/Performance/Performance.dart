// PerformanceScreen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Class/PerformanceClass.dart';
import '../../Class/StudentUserClass.dart';

class PerformanceScreen extends StatefulWidget {
  final List<StudentUser> data_studentUser;

  PerformanceScreen({required this.data_studentUser});

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  late List<Performance> performances = [];
  int selectedYearIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    String apiUrl =
        'http://192.168.1.51/hosting_api/Test_student/st_performance_testing.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<Performance> performanceList = [];

        data['study_performance_data'].forEach((year, yearData) {
          List<Semester> semesters = [];
          yearData.forEach((semester, semesterData) {
            List<Subject> subjects = [];
            semesterData.forEach((subject, subjectData) {
              Attendance attendance =
                  Attendance.fromJson(subjectData['Attendance'][0]);
              StudyScore studyScore =
                  StudyScore.fromJson(subjectData['Study_Score'][0]);

              Subject subjectObj = Subject(
                subjectName: subject,
                attendance: [attendance],
                studyScore: [studyScore],
              );

              subjects.add(subjectObj);
            });

            Semester semesterObj = Semester(
              semesterName: semester,
              subjects: subjects,
            );

            semesters.add(semesterObj);
          });

          Performance performance = Performance(
            yearName: year,
            semesters: semesters,
          );

          performanceList.add(performance);
        });

        setState(() {
          performances = performanceList;
        });

        print(performances); // Print the response for debugging
      } else {
        // Handle error case
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error case
      print('Error: $e');
    }
  }

  void selectYear(int index) {
    setState(() {
      selectedYearIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Performance'),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(10),
            child: performances.isEmpty
                ? Center(
                    child: Text('No Data'),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        children: List.generate(performances.length, (index) {
                          String yearName = performances[index].yearName;
                          return ElevatedButton(
                            onPressed: () => selectYear(index),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                selectedYearIndex == index
                                    ? Colors.indigo.shade900
                                    : Colors.grey.shade400,
                              ),
                            ),
                            child: Text(yearName),
                          );
                        }),
                      ),
                      SizedBox(height: 10),
                      performances[selectedYearIndex].semesters.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: performances[selectedYearIndex]
                                  .semesters
                                  .map((semester) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(semester.semesterName),
                                          ),
                                          Expanded(child: Text('Attendance')),
                                          Expanded(child: Text('Score')),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Column(
                                          children:
                                              semester.subjects.map((subject) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                        subject.subjectName),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(subject
                                                                  .subjectName),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Late'),
                                                                        Text(double.parse(subject.attendance[0].late)
                                                                            .toStringAsFixed(2)),
                                                                      ]),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Absent'),
                                                                        Text(double.parse(subject.attendance[0].absent)
                                                                            .toStringAsFixed(2))
                                                                      ]),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Present'),
                                                                        Text(double.parse(subject.attendance[0].present)
                                                                            .toStringAsFixed(2))
                                                                      ]),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'Close'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text(subject
                                                          .attendance[0]
                                                          .avgAttendance
                                                          .toStringAsFixed(2)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(subject
                                                                  .subjectName),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Attendance'),
                                                                        Text(subject
                                                                            .studyScore[0]
                                                                            .avgAttendance
                                                                            .toStringAsFixed(2))
                                                                      ]),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Exercise'),
                                                                        Text(double.parse(subject.studyScore[0].exercise)
                                                                            .toStringAsFixed(2))
                                                                      ]),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Mid Term'),
                                                                        Text(double.parse(subject.studyScore[0].midTerm)
                                                                            .toStringAsFixed(2))
                                                                      ]),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            'Final'),
                                                                        Text(double.parse(subject.studyScore[0].finalScore)
                                                                            .toStringAsFixed(2))
                                                                      ]),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'Close'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text(subject
                                                          .studyScore[0]
                                                          .scoreAvgStudyScore
                                                          .toString()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          : Center(
                              child: Text('No Data'),
                            )
                    ],
                  ),
          ),
        ));
  }
}
