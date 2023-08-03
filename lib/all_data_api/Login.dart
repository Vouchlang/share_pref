import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'Class/AchievementClass.dart';
import 'Class/Class_Survey.dart';
import 'Class/CreditClass.dart';
import 'Class/FeedbackClass.dart';
import 'Class/JobHistoryClass.dart';
import 'Class/ScheduleClass.dart';
import 'Class/StDetailClass.dart';
import 'Class/StudentUserClass.dart';
import 'Class/StudyInfoClass.dart';
import 'Class/SurveyClass.dart';
import '../Custom_AppBar.dart';
import 'Screen/DashBoard.dart';

class LoginPage1 extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage1> {
  List<Class_Survey> survey = [];

  final _formKey = GlobalKey<FormState>();
  final _textControllerUsername = TextEditingController();
  final _textControllerPsw = TextEditingController();
  final Uri urlFb = Uri.parse("https://www.youtube.com/watch?v=lPa9i-CLS-g");

  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = true;

  Future<void> getData() async {
    try {
      var res = await http.get(
        Uri.parse("http://192.168.1.51/hosting_api/Student/student_survey.php"),
      );
      var r = json.decode(res.body);
      if (r is List<dynamic>) {
        survey = r.map((e) => Class_Survey.fromJson(e)).toList();
      } else {
        survey = [
          Class_Survey.fromJson(r),
        ];
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void launch_survey() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ធ្វើ Survey'),
              Text(
                'ចូលធ្វើសឺវេសិនប្រូ?',
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Text('បោះបង់'),
                      onPressed: () {
                        onSuccess();
                      },
                    ),
                    TextButton(
                      child: Text('Okay Bro'),
                      onPressed: () async {
                        launchUrl(Uri.parse(survey[0].survey_link));
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

  void onSuccess() async {
    final String studentId = _textControllerUsername.text;
    final String password = _textControllerPsw.text;

    final url =
        'http://192.168.1.51/hosting_api/Test_Student/student_login_testing.php';
    final response = await http.post(Uri.parse(url), body: {
      'student_id': studentId,
      'pwd': password,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        final studentUserData = data['student_users'];

        List<StudentUser> dataList_StudentUser = [];
        for (var item in studentUserData) {
          StudentUser dataModel1 = StudentUser(
            name_kh: item['name_kh'],
            student_id: item['student_id'],
            pwd: item['pwd'],
          );
          dataList_StudentUser.add(dataModel1);
        }

        SharedPreferences sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool('login', true);
        saveStudentUser(sharedPref, dataList_StudentUser);

        Get.offAll(DashBoard(
          data_studentUser: dataList_StudentUser,
        ));
      } else {
        print('Error');
      }
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('គណនីនិស្សិត'),
                  Text(
                    'អត្តលេខនិស្សិត ឬពាក្យសម្ងាត់មិនត្រឹមត្រូវ។ សូមបញ្ចូលម្ដងទៀត!!!',
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      child: Text('OK'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void saveStudentUser(
      SharedPreferences sharedPreferences, List<StudentUser> studentUserList) {
    final jsonData =
        studentUserList.map((studentUser) => studentUser.toJson()).toList();
    sharedPreferences.setString('student_user', json.encode(jsonData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: Custom_AppBar(title: 'គណនីនិសិ្សត'),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _textControllerUsername,
                decoration: InputDecoration(
                  labelText: 'លេខនិស្សិត',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'សូមបញ្ចូលលេខនិស្សិត';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _textControllerPsw,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'ពាក្យសម្ងាត់',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'សូមបញ្ចូលពាក្យសម្ងាត់';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  if (survey[0].survey_link.isNotEmpty) {
                    launch_survey();
                  } else {
                    onSuccess();
                  }
                },
                child: Text('ចូល'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
