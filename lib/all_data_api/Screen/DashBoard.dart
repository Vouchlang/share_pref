import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_pref/First.dart';
import 'package:share_pref/all_data_api/Screen/PayStudy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Class/CreditClass.dart';
import '../Class/FeedbackClass.dart';
import '../Class/StudentUserClass.dart';
import '../Class/SurveyClass.dart';
import '../HomePage.dart';
import 'Achievement.dart';
import 'Attendance/Attendance.dart';
import 'Attendance/AttendanceList.dart';
import 'Chart.dart';
import 'JobHistory.dart';
import 'Performance/Performance.dart';
import 'Schedule.dart';
import 'StDetail.dart';
import 'StudyInfo.dart';
import 'Survey.dart';

class DashBoard extends StatefulWidget {
  final List<StudentUser> data_studentUser;

  const DashBoard({
    Key? key,
    required this.data_studentUser,
  }) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool isLoading = false;
  late List<StudentUser> _dataStudentUser;
  late List<Survey_Class> _dataSurvey = [];
  late List<Credit> _dataCredit = [];
  late List<FeedbackClass> _dataFeedback = [];

  @override
  void initState() {
    super.initState();
    _dataStudentUser = widget.data_studentUser;
    _refreshData();
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ចាកចេញ'),
              Text('តើអ្នកប្រាកដថាអ្នកនឹងចាកចេញពីគណនីសិស្សដែរឬទេ?'),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('បោះបង់'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('ចាកចេញ'),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MyHomePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_Student/student_login_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      var response1 = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_student/st_chart_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      var response2 = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_student/st_survey_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      var response3 = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_student/st_feedback_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200 &&
          response1.statusCode == 200 &&
          response2.statusCode == 200 &&
          response3.statusCode == 200) {
        var data = jsonDecode(response.body);
        var data1 = jsonDecode(response1.body);
        var data2 = jsonDecode(response2.body);
        var data3 = jsonDecode(response3.body);

        setState(() {
          _dataStudentUser = List<StudentUser>.from(
              data['student_users'].map((data) => StudentUser.fromJson(data)));
          _dataCredit = List<Credit>.from(
              data1['credit_data'].map((data1) => Credit.fromJson(data1)));
          _dataSurvey = List<Survey_Class>.from(data2['survey_status']
              .map((data2) => Survey_Class.fromJson(data2)));
          _dataFeedback = List<FeedbackClass>.from(data3['feedback_data']
              .map((data3) => FeedbackClass.fromJson(data3)));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData();
  }

  double calculatePercentIndicator() {
    if (_dataCredit.isEmpty || _dataCredit[0].totalCredit == "0") {
      return 0; // Avoid division by zero error
    }

    double yourCredit = double.parse(_dataCredit[0].yourCredit);
    double totalCredit = double.parse(_dataCredit[0].totalCredit);

    double percentIndicator = yourCredit / totalCredit;
    return percentIndicator;
  }

  @override
  Widget build(BuildContext context) {
    double percentIndicator = calculatePercentIndicator();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(_dataSurvey.isNotEmpty
              ? _dataSurvey[0].survey_teacher.toString()
              : ''),
          leading: IconButton(
            icon: Icon(Icons.logout),
            iconSize: 20,
            onPressed: () {
              _logout();
            },
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Get.off(First());
                },
                child: Icon(Icons.home))
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: Center(
                  child: SingleChildScrollView(
                    child: (() {
                      if (_dataSurvey.isNotEmpty) {
                        if (_dataSurvey.length > 1) {
                          return Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(AttendanceScreen(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('1 Attendance'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(PerformanceScreen(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('1 Study Performance'),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Get.to(Achievement(
                                      data_studentUser: _dataStudentUser,
                                    ));
                                  },
                                  child: Text('Achievement')),
                              CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 50.0,
                                percent: percentIndicator,
                                progressColor: Colors.indigo[900],
                                animateFromLastPercent: true,
                                animation: true,
                                animationDuration: 750,
                                backgroundColor: Colors.indigo.shade100,
                                center: Text(
                                  _dataCredit.isNotEmpty
                                      ? '${_dataCredit[0].yourCredit} / ${_dataCredit[0].totalCredit}'
                                      : 'N/A',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Get.to(MyPercentIndicatorScreen(
                                      data_studentUser: _dataStudentUser,
                                    ));
                                  },
                                  child: Text('Chart')),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 3,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Choose Survey',
                                              ),
                                              Text(
                                                'សូមជ្រើសរើស Survey',
                                              ),
                                              SizedBox(height: 5),
                                              Flexible(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _dataSurvey.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              launchUrl(Uri.parse(
                                                                  _dataSurvey[
                                                                          index]
                                                                      .survey_link));
                                                            },
                                                            child: Text(_dataSurvey[
                                                                    index]
                                                                .survey_teacher),
                                                          )
                                                        ],
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Text('1 Take Survey'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(Survey_Screen(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('1 Survey'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(Job_History(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('1 JobHistory'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(StudentDetail(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('1 Student Detail'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(Schedule(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('1 Schedule'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(StudyInfo(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('1 Study Info'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _dataFeedback.isEmpty
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: Column(
                                                children: [
                                                  ElevatedButton(
                                                      onPressed:
                                                          Navigator.of(context)
                                                              .pop,
                                                      child: Text('No Data'))
                                                ],
                                              ),
                                            );
                                          })
                                      : launchUrl(
                                          Uri.parse(_dataFeedback[0].feedback));
                                },
                                child: Text('1 Feedback'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(Payment_Study(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('1 Study Payment'),
                              ),
                              Container(
                                height: 700,
                                color: Colors.amber,
                              )
                            ],
                          );
                        } else if (_dataSurvey.length == 1) {
                          return Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(PerformanceScreen(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('0 Study Performance'),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Get.to(Achievement(
                                      data_studentUser: _dataStudentUser,
                                    ));
                                  },
                                  child: Text('Achievement')),
                              ElevatedButton(
                                onPressed: () {
                                  launchUrl(
                                      Uri.parse(_dataSurvey[0].survey_link));
                                },
                                child: Text('0 Take Survey'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(Survey_Screen(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('0 Survey'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(Job_History(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('0 JobHistory'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(StudentDetail(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('0 Student Detail'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(Schedule(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('0 Schedule'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(StudyInfo(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('0 Study Info'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _dataFeedback.isEmpty
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: Column(
                                                children: [
                                                  ElevatedButton(
                                                      onPressed:
                                                          Navigator.of(context)
                                                              .pop,
                                                      child: Text('No Data'))
                                                ],
                                              ),
                                            );
                                          })
                                      : launchUrl(
                                          Uri.parse(_dataFeedback[0].feedback));
                                },
                                child: Text('0 Feedback'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(Payment_Study(
                                    data_studentUser: _dataStudentUser,
                                  ));
                                },
                                child: Text('1 Study Payment'),
                              ),
                              Container(
                                height: 700,
                                color: Colors.amber,
                              )
                            ],
                          );
                        }
                      }
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.to(PerformanceScreen(
                                data_studentUser: _dataStudentUser,
                              ));
                            },
                            child: Text('Study Performance'),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Get.to(Achievement(
                                  data_studentUser: _dataStudentUser,
                                ));
                              },
                              child: Text('Achievement')),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(Survey_Screen(
                                data_studentUser: _dataStudentUser,
                              ));
                            },
                            child: Text('0 Survey'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(Job_History(
                                data_studentUser: _dataStudentUser,
                              ));
                            },
                            child: Text('0 JobHistory'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(StudentDetail(
                                data_studentUser: _dataStudentUser,
                              ));
                            },
                            child: Text('0 Student Detail'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(Schedule(
                                data_studentUser: _dataStudentUser,
                              ));
                            },
                            child: Text('0 Schedule'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(StudyInfo(
                                data_studentUser: _dataStudentUser,
                              ));
                            },
                            child: Text('5 Study Info'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _dataFeedback.isEmpty
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Column(
                                            children: [
                                              ElevatedButton(
                                                  onPressed:
                                                      Navigator.of(context).pop,
                                                  child: Text('No Data'))
                                            ],
                                          ),
                                        );
                                      })
                                  : launchUrl(
                                      Uri.parse(_dataFeedback[0].feedback));
                            },
                            child: Text('1 Feedback'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(Payment_Study(
                                data_studentUser: _dataStudentUser,
                              ));
                            },
                            child: Text('1 Study Payment'),
                          ),
                          Container(
                            height: 700,
                            color: Colors.amber,
                          )
                        ],
                      );
                    })(),
                  ),
                ),
              ));
  }
}
