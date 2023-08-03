import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Class/JobHistoryClass.dart';
import '../Class/StudentUserClass.dart';

class Job_History extends StatefulWidget {
  final List<StudentUser> data_studentUser;

  Job_History({
    Key? key,
    required this.data_studentUser,
  }) : super(key: key);

  @override
  State<Job_History> createState() => _Job_HistoryState();
}

class _Job_HistoryState extends State<Job_History> {
  bool isLoading = false;
  List<JobHistory> _dataJobHistory = [];

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
            'http://192.168.1.51/hosting_api/Test_student/st_workplace_testing.php'),
        body: {
          'student_id': widget.data_studentUser[0].student_id,
          'pwd': widget.data_studentUser[0].pwd,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          _dataJobHistory = List<JobHistory>.from(data['job_history_data']
              .map((data) => JobHistory.fromJson(data)));
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
        title: Text('Job History'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _dataJobHistory.isEmpty
              ? RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('No Data'),
                        Container(
                          height: 1300,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    itemCount: _dataJobHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_dataJobHistory[index].workPlace),
                        subtitle: Text(_dataJobHistory[index].position),
                        trailing:
                            Text(_dataJobHistory[index].salary.toString()),
                      );
                    },
                  ),
                ),
    );
  }
}
