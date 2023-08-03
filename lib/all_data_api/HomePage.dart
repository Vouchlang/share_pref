import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'Login.dart';
import 'Class/StudentUserClass.dart';
import 'Screen/DashBoard.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const String KEYLOGIN = 'login';
  static const String KEYSTUDENT_USER = 'student_user';

  final Uri urlFb = Uri.parse("https://www.youtube.com/watch?v=lPa9i-CLS-g");

  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  void whereToGo() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPreferences.getBool(KEYLOGIN);

    if (isLoggedIn != null && isLoggedIn) {
      List<StudentUser> dataStudentUser =
          getSavedStudentUser(sharedPreferences);

      if (isLoggedIn) {
        navigateToDashboardScreen(
          dataStudentUser,
        );
      } else {
        navigateToLoginPage();
      }
    }
  }

  List<StudentUser> getSavedStudentUser(SharedPreferences sharedPreferences) {
    final studentUserString = sharedPreferences.getString(KEYSTUDENT_USER);
    if (studentUserString != null) {
      final jsonData = json.decode(studentUserString);
      List<StudentUser> studentUserList = [];
      for (var item in jsonData) {
        StudentUser studentUser = StudentUser.fromJson(item);
        studentUserList.add(studentUser);
      }
      return studentUserList;
    } else {
      return [];
    }
  }

  void navigateToDashboardScreen(
    List<StudentUser> studentUser,
  ) {
    Get.off(DashBoard(
      data_studentUser: studentUser,
    ));
  }

  void navigateToLoginPage() {
    Get.off(LoginPage1());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                launchUrl(urlFb.toString());
              },
              child: const Text('Open Facebook'),
            ),
            ElevatedButton(
              onPressed: () {
                navigateToLoginPage();
              },
              child: const Text('Go to Login Page'),
            ),
          ],
        ),
      ),
    );
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
