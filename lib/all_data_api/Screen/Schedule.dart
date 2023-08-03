import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/ScheduleClass.dart';
import '../Class/StudentUserClass.dart';

class Schedule extends StatefulWidget {
  final List<StudentUser> data_studentUser;
  // final List<ScheduleClass> data_schedule;

  Schedule({
    Key? key,
    // required this.data_schedule,
    required this.data_studentUser,
  }) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool isLoading = false;
  late List<ScheduleClass> _dataSchedule = [];

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
            'http://192.168.1.51/hosting_api/Test_student/st_schedule_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          _dataSchedule = List<ScheduleClass>.from(data['schedule_data']
              .map((data) => ScheduleClass.fromJson(data)));
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
          title: Text('Schedule'),
        ),
        body: _dataSchedule.isEmpty
            ? Center(
                child: Text('No Data'),
              )
            : RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _dataSchedule.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_dataSchedule[index].weekday),
                          Text(_dataSchedule[index].date),
                          Text(_dataSchedule[index].classroom),
                          Text(_dataSchedule[index].subject),
                          Text(_dataSchedule[index].teacherName),
                          Text(_dataSchedule[index].tel),
                        ],
                      ),
                    );
                  },
                ),
              ));
  }
}
