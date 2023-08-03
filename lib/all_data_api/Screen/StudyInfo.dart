import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/StudentUserClass.dart';
import '../Class/StudyInfoClass.dart';

class StudyInfo extends StatefulWidget {
  final List<StudentUser> data_studentUser;
  // final List<StudyInfoClass> data_studyInfo;

  StudyInfo({
    Key? key,
    // required this.data_studyInfo,
    required this.data_studentUser,
  }) : super(key: key);

  @override
  State<StudyInfo> createState() => _StudyInfoState();
}

class _StudyInfoState extends State<StudyInfo> {
  bool isLoading = false;
  late List<StudyInfoClass> _dataStudyInfo = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(
            'http://192.168.1.51/hosting_api/Test_student/st_study_info_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          _dataStudyInfo = List<StudyInfoClass>.from(data['study_info_data']
              .map((data) => StudyInfoClass.fromJson(data)));
          isLoading = false;
        });
      } else {
        // Handle the response status code other than 200
        print('Response Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Study Info'),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _dataStudyInfo.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(_dataStudyInfo[index].date),
                    Text(_dataStudyInfo[index].month),
                    Text(_dataStudyInfo[index].title),
                    Text(_dataStudyInfo[index].subject),
                    Text(_dataStudyInfo[index].room),
                    Text(_dataStudyInfo[index].time),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
